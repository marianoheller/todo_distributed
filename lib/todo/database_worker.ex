defmodule Todo.DatabaseWorker do
  use GenServer

  def start_link(db_folder, worker_id) do
    IO.puts("Starting the database worker #{worker_id}")

    GenServer.start_link(
      __MODULE__,
      db_folder,
      name: via_tuple(worker_id)
    )
  end

  def store(worker_id, key, data) do
    GenServer.call(via_tuple(worker_id), {:store, key, data})
  end

  def get(worker_id, key) do
    GenServer.call(via_tuple(worker_id), {:get, key})
  end

  def init(db_folder) do
    File.mkdir_p(db_folder)
    {:ok, db_folder}
  end

  def handle_call({:store, key, data}, caller, db_folder) do
    spawn(fn ->
      file_name(db_folder, key)
      |> File.write!(:erlang.term_to_binary(data))

      GenServer.reply(caller, {:ok, data})
    end)

    {:noreply, db_folder}
  end

  def handle_call({:get, key}, caller, db_folder) do
    spawn(fn ->
      data =
        case File.read(file_name(db_folder, key)) do
          {:ok, contents} -> :erlang.binary_to_term(contents)
          _ -> nil
        end

      GenServer.reply(caller, data)
    end)

    {:noreply, db_folder}
  end

  defp file_name(db_folder, key), do: "#{db_folder}/#{key}"

  defp via_tuple(worker_id) do
    {:via, :gproc, {:n, :l, {:database_worker, worker_id}}}
  end
end
