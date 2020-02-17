defmodule Todo.Server do
  use GenServer

  def start_link(name) do
    IO.puts("Starting to-do server for #{name}")
    GenServer.start_link(Todo.Server, name, name: via_tuple(name))
  end

  defp via_tuple(name) do
    {:via, :gproc, {:n, :l, {:todo_server, name}}}
  end

  def whereis(name) do
    :gproc.whereis_name({:n, :l, {:todo_server, name}})
  end

  def add_entry(pid, new_entry) when is_pid(pid) do
    GenServer.cast(pid, {:add_entry, new_entry})
  end

  def entries(pid, key) when is_pid(pid) do
    case key do
      nil ->
        GenServer.call(pid, {:entries})

      _ ->
        GenServer.call(pid, {:entries, key})
    end
  end

  def init(name) do
    send(self(), {:real_init, name})
    {:ok, nil}
  end

  def handle_cast({:add_entry, new_entry}, {name, todo_list}) do
    new_state = Todo.List.add_entry(todo_list, new_entry)
    Todo.Database.store(name, new_state)
    {:noreply, {name, new_state}}
  end

  def handle_call({:entries, key}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list, key), {name, todo_list}}
  end

  def handle_call({:entries}, _, {name, todo_list}) do
    {:reply, Todo.List.entries(todo_list), {name, todo_list}}
  end

  def handle_info({:real_init, name}, _) do
    {:noreply, {name, Todo.Database.get(name) || Todo.List.new()}}
  end

  def handle_info(_, state) do
    state
  end
end
