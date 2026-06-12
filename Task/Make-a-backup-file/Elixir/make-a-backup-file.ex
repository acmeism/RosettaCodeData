defmodule RC do
  def backup_file(filename) do
    backup = filename <> ".backup"
    case File.rename(filename, backup) do
      :ok -> :ok
      {:error, reason} -> raise "rename error: #{reason}"
    end
    File.cp!(backup, filename)
  end
end

hd(System.argv) |> RC.backup_file
