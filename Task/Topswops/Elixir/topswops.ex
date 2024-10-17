defmodule Topswops do
  def get_1_first( [1 | _t] ), do: 0
  def get_1_first( list ), do: 1 + get_1_first( swap(list) )

  defp swap( [n | _t]=list ) do
    {swaps, remains} = Enum.split( list, n )
    Enum.reverse( swaps, remains )
  end

  def task do
    IO.puts "N\ttopswaps"
    Enum.map(1..10, fn n -> {n, permute(Enum.to_list(1..n))} end)
    |> Enum.map(fn {n, n_permutations} -> {n, get_1_first_many(n_permutations)} end)
    |> Enum.map(fn {n, n_swops} -> {n, Enum.max(n_swops)} end)
    |> Enum.each(fn {n, max} -> IO.puts "#{n}\t#{max}" end)
  end

  def get_1_first_many( n_permutations ), do: (for x <- n_permutations, do: get_1_first(x))

  defp permute([]), do: [[]]
  defp permute(list), do: for x <- list, y <- permute(list -- [x]), do: [x|y]
end

Topswops.task
