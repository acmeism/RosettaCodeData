defmodule Division do
  def by_zero?(x,y) do
    try do
      _ = x / y
      false
    rescue
      ArithmeticError -> true
    end
  end
end

[{2, 3}, {3, 0}, {0, 5}, {0, 0}, {2.0, 3.0}, {3.0, 0.0}, {0.0, 5.0}, {0.0, 0.0}]
|> Enum.each(fn {x,y} ->
  IO.puts "#{x} / #{y}\tdivision by zero  #{Division.by_zero?(x,y)}"
end)
