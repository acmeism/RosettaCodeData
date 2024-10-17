defmodule Floyd do
  def triangle(n) do
    max = trunc(n * (n + 1) / 2)
    widths = for m <- (max - n + 1)..max, do: (m |> Integer.to_string |> String.length) + 1
    format = Enum.map(widths, fn wide -> "~#{wide}w" end) |> List.to_tuple
    line(n, 0, 1, format)
  end

  def line(n, n, _, _), do: :ok
  def line(n, i, count, format) do
    Enum.each(0..i, fn j -> :io.fwrite(elem(format,j), [count+j]) end)
    IO.puts ""
    line(n, i+1, count+i+1, format)
  end
end

Floyd.triangle(5)
Floyd.triangle(14)
