defmodule Roman_numeral do
  def encode(0), do: ''
  def encode(x) when x >= 1000, do: [?M | encode(x - 1000)]
  def encode(x) when x >= 100,  do: digit(div(x,100), ?C, ?D, ?M) ++ encode(rem(x,100))
  def encode(x) when x >= 10,   do: digit(div(x,10), ?X, ?L, ?C) ++ encode(rem(x,10))
  def encode(x) when x >= 1,    do: digit(x, ?I, ?V, ?X)

  defp digit(1, x, _, _), do: [x]
  defp digit(2, x, _, _), do: [x, x]
  defp digit(3, x, _, _), do: [x, x, x]
  defp digit(4, x, y, _), do: [x, y]
  defp digit(5, _, y, _), do: [y]
  defp digit(6, x, y, _), do: [y, x]
  defp digit(7, x, y, _), do: [y, x, x]
  defp digit(8, x, y, _), do: [y, x, x, x]
  defp digit(9, x, _, z), do: [x, z]
end
