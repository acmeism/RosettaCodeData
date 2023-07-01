defmodule Write_float_arrays do
  def task(xs, ys, fname, precision\\[]) do
    xprecision = Keyword.get(precision, :x, 2)
    yprecision = Keyword.get(precision, :y, 3)
    format = "~.#{xprecision}g\t~.#{yprecision}g~n"
    File.open!(fname, [:write], fn file ->
      Enum.zip(xs, ys)
      |> Enum.each(fn {x, y} -> :io.fwrite file, format, [x, y] end)
    end)
  end
end

x = [1.0, 2.0, 3.0, 1.0e11]
y = for n <- x, do: :math.sqrt(n)
fname = "filename.txt"

Write_float_arrays.task(x, y, fname)
IO.puts File.read!(fname)

precision = [x: 3, y: 5]
Write_float_arrays.task(x, y, fname, precision)
IO.puts File.read!(fname)
