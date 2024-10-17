defmodule Prime do
  def semiprime?(n), do: length(decomposition(n)) == 2

  def decomposition(n), do: decomposition(n, 2, [])

  defp decomposition(n, k, acc) when n < k*k, do: Enum.reverse(acc, [n])
  defp decomposition(n, k, acc) when rem(n, k) == 0, do: decomposition(div(n, k), k, [k | acc])
  defp decomposition(n, k, acc), do: decomposition(n, k+1, acc)
end

IO.inspect Enum.filter(1..100, &Prime.semiprime?(&1))
Enum.each(1675..1680, fn n ->
  :io.format "~w -> ~w\t~s~n", [n, Prime.semiprime?(n), Prime.decomposition(n)|>Enum.join(" x ")]
end)
