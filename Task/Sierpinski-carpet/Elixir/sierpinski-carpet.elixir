defmodule RC do
  def sierpinski_carpet(n), do: sierpinski_carpet(n, ["#"])

  def sierpinski_carpet(0, carpet), do: carpet
  def sierpinski_carpet(n, carpet) do
    new_carpet = Enum.map(carpet, fn x -> x <> x <> x end) ++
                 Enum.map(carpet, fn x -> x <> String.replace(x, "#", " ") <> x end) ++
                 Enum.map(carpet, fn x -> x <> x <> x end)
    sierpinski_carpet(n-1, new_carpet)
  end
end

Enum.each(0..3, fn n ->
  IO.puts "\nN=#{n}"
  Enum.each(RC.sierpinski_carpet(n), fn line -> IO.puts line end)
end)
