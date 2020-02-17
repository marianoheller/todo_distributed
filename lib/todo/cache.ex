defmodule Todo.Cache do
  use GenServer

  def start_link do
    IO.puts("Starting to-do cache.")
    GenServer.start_link(__MODULE__, nil, name: :todo_cache)
  end

  def server_process(todo_list_name) do
    IO.puts("Running cache check of to-do server for #{todo_list_name}")

    case Todo.Server.whereis(todo_list_name) do
      :undefined -> GenServer.call(:todo_cache, {:server_process, todo_list_name})
      pid -> pid
    end
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:server_process, todo_list_name}, _, nil) do
    case Todo.Server.whereis(todo_list_name) do
      :undefined ->
        pid = Todo.ServerSupervisor.start_child(todo_list_name)
        {:reply, pid, nil}

      pid ->
        {:reply, pid, nil}
    end
  end
end
