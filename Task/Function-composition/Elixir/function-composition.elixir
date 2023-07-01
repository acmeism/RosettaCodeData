defmodule RC do
  def compose(f, g), do: fn(x) -> f.(g.(x)) end

  def multicompose(fs), do: List.foldl(fs, fn(x) -> x end, &compose/2)
end

sin_asin = RC.compose(&:math.sin/1, &:math.asin/1)
IO.puts sin_asin.(0.5)

IO.puts RC.multicompose([&:math.sin/1, &:math.asin/1, fn x->1/x end]).(0.5)
IO.puts RC.multicompose([&(&1*&1), &(1/&1), &(&1*&1)]).(0.5)
