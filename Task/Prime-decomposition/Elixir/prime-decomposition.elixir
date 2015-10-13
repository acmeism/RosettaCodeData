defmodule Prime do
  def decomposition(n), do: decomposition(n, 2, [])

  defp decomposition(n, k, acc) when n < k*k, do: Enum.reverse(acc, [n])
  defp decomposition(n, k, acc) when rem(n, k) == 0, do: decomposition(div(n, k), k, [k | acc])
  defp decomposition(n, k, acc), do: decomposition(n, k+1, acc)
end

prime = Stream.iterate(2, &(&1+1)) |>
        Stream.filter(fn n-> length(Prime.decomposition(n)) == 1 end) |>
        Enum.take(17)
mersenne = Enum.map(prime, fn n -> {n, round(:math.pow(2,n)) - 1} end)
Enum.each(mersenne, fn {n,m} ->
  :io.format "~3s :~20w = ~s~n", ["M#{n}", m, Prime.decomposition(m) |> Enum.join(" x ")]
end)
