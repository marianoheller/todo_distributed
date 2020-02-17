defmodule Todo.PoolSupervisor do
  use Supervisor

  def start_link(db_folder, pool_size) do
    IO.puts("Starting pool supervisor")
    Supervisor.start_link(__MODULE__, {db_folder, pool_size})
  end

  @impl true
  def init({db_folder, pool_size}) do
    children =
      for worker_id <- 1..pool_size do
        worker(
          Todo.DatabaseWorker,
          [db_folder, worker_id],
          id: {:database_worker, worker_id}
        )
      end

    Supervisor.init(children, strategy: :one_for_one)
  end
end
