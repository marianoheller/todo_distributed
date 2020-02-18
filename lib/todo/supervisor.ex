defmodule Todo.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, nil)
  end

  @impl true
  def init(_) do
    children = [
      supervisor(Todo.Database, ["./persist/"]),
      supervisor(Todo.ServerSupervisor, [])
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
