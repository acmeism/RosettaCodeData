defmodule Sort do
  def bead_sort(list) when is_list(list), do: dist(dist(list))

  defp dist(list), do: List.foldl(list, [], fn(n, acc) when n>0 -> dist(acc, n, []) end)

  defp dist([],    0, acc), do: Enum.reverse(acc)
  defp dist([h|t], 0, acc), do: dist(t,    0, [h  |acc])
  defp dist([],    n, acc), do: dist([], n-1, [1  |acc])
  defp dist([h|t], n, acc), do: dist(t,  n-1, [h+1|acc])
end
