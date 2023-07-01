defmodule LineReader do
  def get_line(filename, line) do
    File.stream!(filename)
    |> Stream.with_index
    |> Stream.filter(fn {_value, index} -> index == line-1 end)
    |> Enum.at(0)
    |> print_line
  end
  defp print_line({value, _line_number}), do: String.trim(value)
  defp print_line(_), do: {:error, "Invalid Line"}
end
