defmodule Proper do
  def divisors(1), do: []
  def divisors(n), do: [1 | divisors(2,n,:math.sqrt(n))] |> Enum.sort

  defp divisors(k,_n,q) when k>q, do: []
  defp divisors(k,n,q) when rem(n,k)>0, do: divisors(k+1,n,q)
  defp divisors(k,n,q) when k * k == n, do: [k | divisors(k+1,n,q)]
  defp divisors(k,n,q)                , do: [k,div(n,k) | divisors(k+1,n,q)]
end

map = Map.new(1..20000, fn n -> {n, Proper.divisors(n) |> Enum.sum} end)
Enum.filter(map, fn {n,sum} -> map[sum] == n and n < sum end)
|> Enum.sort
|> Enum.each(fn {i,j} -> IO.puts "#{i} and #{j}" end)
