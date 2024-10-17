defmodule Proper do
  def divisors(1), do: []
  def divisors(n), do: [1 | divisors(2,n,:math.sqrt(n))] |> Enum.sort

  defp divisors(k,_n,q) when k>q, do: []
  defp divisors(k,n,q) when rem(n,k)>0, do: divisors(k+1,n,q)
  defp divisors(k,n,q) when k * k == n, do: [k | divisors(k+1,n,q)]
  defp divisors(k,n,q)                , do: [k,div(n,k) | divisors(k+1,n,q)]

  def most_divisors(limit) do
    {length,nums} = Enum.group_by(1..limit, fn n -> length(divisors(n)) end)
                    |> Enum.max_by(fn {length,_nums} -> length end)
    IO.puts "With #{length}, Number #{inspect nums} has the most divisors"
  end
end

Enum.each(1..10, fn n ->
  IO.puts "#{n}: #{inspect Proper.divisors(n)}"
end)
Proper.most_divisors(20000)
