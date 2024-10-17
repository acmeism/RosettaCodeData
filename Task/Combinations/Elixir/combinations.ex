defmodule RC do
  def comb(0, _), do: [[]]
  def comb(_, []), do: []
  def comb(m, [h|t]) do
    (for l <- comb(m-1, t), do: [h|l]) ++ comb(m, t)
  end
end

{m, n} = {3, 5}
list = for i <- 1..n, do: i
Enum.each(RC.comb(m, list), fn x -> IO.inspect x end)
