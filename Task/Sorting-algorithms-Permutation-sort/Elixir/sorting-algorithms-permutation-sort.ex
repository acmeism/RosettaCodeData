defmodule Sort do
  def permutation_sort([]), do: []
  def permutation_sort(list) do
    Enum.find(permutation(list), fn [h|t] -> in_order?(t, h) end)
  end

  defp permutation([]), do: [[]]
  defp permutation(list) do
    for x <- list, y <- permutation(list -- [x]), do: [x|y]
  end

  defp in_order?([], _), do: true
  defp in_order?([h|_], pre) when h<pre, do: false
  defp in_order?([h|t], _), do: in_order?(t, h)
end

IO.inspect list = for _ <- 1..9, do: :rand.uniform(20)
IO.inspect Sort.permutation_sort(list)
