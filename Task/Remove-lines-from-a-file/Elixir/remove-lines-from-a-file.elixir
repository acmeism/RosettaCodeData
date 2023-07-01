defmodule RC do
  def remove_lines(filename, start, number) do
    File.open!(filename, [:read], fn file ->
      remove_lines(file, start, number, IO.read(file, :line))
    end)
  end

  defp remove_lines(_file, 0, 0, :eof), do: :ok
  defp remove_lines(_file, _, _, :eof) do
    IO.puts(:stderr, "Warning: End of file encountered before all lines removed")
  end
  defp remove_lines(file, 0, 0, line) do
    IO.write line
    remove_lines(file, 0, 0, IO.read(file, :line))
  end
  defp remove_lines(file, 0, number, _line) do
    remove_lines(file, 0, number-1, IO.read(file, :line))
  end
  defp remove_lines(file, start, number, line) do
    IO.write line
    remove_lines(file, start-1, number, IO.read(file, :line))
  end
end

[filename, start, number] = System.argv
IO.puts "before:"
IO.puts File.read!(filename)
IO.puts "after:"
RC.remove_lines(filename, String.to_integer(start), String.to_integer(number)
