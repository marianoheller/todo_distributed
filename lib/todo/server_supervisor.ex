defmodule Todo.ServerSupervisor do
  use DynamicSupervisor

  def start_link do
    DynamicSupervisor.start_link(__MODULE__, nil, name: :todo_server_supervisor)
  end

  def start_child(todo_list_name) do
    spec = {Todo.Server, todo_list_name}
    DynamicSupervisor.start_child(:todo_server_supervisor, spec)
  end

  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
