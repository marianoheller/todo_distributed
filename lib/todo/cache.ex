defmodule Todo.Cache do
  def server_process(todo_list_name) do
    IO.puts("Running cache check of to-do server for #{todo_list_name}")

    case Todo.Server.whereis(todo_list_name) do
      :undefined -> create_server(todo_list_name)
      pid -> pid
    end
  end

  defp create_server(todo_list_name) do
    case Todo.ServerSupervisor.start_child(todo_list_name) do
      {:ok, pid} -> pid
      {:error, {:already_started, pid}} -> pid
    end
  end
end
