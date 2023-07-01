defmodule RC do
  def factor(1), do: [1]
  def factor(n) do
    (for i <- 1..div(n,2), rem(n,i)==0, do: i) ++ [n]
  end

  # Recursive (faster version);
  def divisor(n), do: divisor(n, 1, []) |> Enum.sort

  defp divisor(n, i, factors) when n < i*i    , do: factors
  defp divisor(n, i, factors) when n == i*i   , do: [i | factors]
  defp divisor(n, i, factors) when rem(n,i)==0, do: divisor(n, i+1, [i, div(n,i) | factors])
  defp divisor(n, i, factors)                 , do: divisor(n, i+1, factors)
end

Enum.each([45, 53, 60, 64], fn n ->
  IO.puts "#{n}: #{inspect RC.factor(n)}"
end)

IO.puts "\nRange: #{inspect range = 1..10000}"
funs = [ factor:  &RC.factor/1,
         divisor: &RC.divisor/1 ]
Enum.each(funs, fn {name, fun} ->
  {time, value} = :timer.tc(fn -> Enum.count(range, &length(fun.(&1))==2) end)
  IO.puts "#{name}\t prime count : #{value},\t#{time/1000000} sec"
end)
