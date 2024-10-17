defmodule Proper do
  def divisors(1), do: []
  def divisors(n), do: [1 | divisors(2,n,:math.sqrt(n))] |> Enum.sort

  defp divisors(k,_n,q) when k>q, do: []
  defp divisors(k,n,q) when rem(n,k)>0, do: divisors(k+1,n,q)
  defp divisors(k,n,q) when k * k == n, do: [k | divisors(k+1,n,q)]
  defp divisors(k,n,q)                , do: [k,div(n,k) | divisors(k+1,n,q)]
end

{abundant, deficient, perfect} = Enum.reduce(1..20000, {0,0,0}, fn n,{a, d, p} ->
  sum = Proper.divisors(n) |> Enum.sum
  cond do
    n < sum -> {a+1, d, p}
    n > sum -> {a, d+1, p}
    true    -> {a, d, p+1}
  end
end)
IO.puts "Deficient: #{deficient}   Perfect: #{perfect}   Abundant: #{abundant}"
