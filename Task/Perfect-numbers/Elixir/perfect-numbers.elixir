defmodule RC do
  def is_perfect(1), do: false
  def is_perfect(n) when n > 1 do
    Enum.sum(factor(n, 2, [1])) == n
  end

  defp factor(n, i, factors) when n <  i*i   , do: factors
  defp factor(n, i, factors) when n == i*i   , do: [i | factors]
  defp factor(n, i, factors) when rem(n,i)==0, do: factor(n, i+1, [i, div(n,i) | factors])
  defp factor(n, i, factors)                 , do: factor(n, i+1, factors)
end

IO.inspect (for i <- 1..10000, RC.is_perfect(i), do: i)
