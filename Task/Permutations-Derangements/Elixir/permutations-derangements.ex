defmodule Permutation do
  def derangements(n) do
    list = Enum.to_list(1..n)
    Enum.filter(permutation(list), fn perm ->
      Enum.zip(list, perm) |> Enum.all?(fn {a,b} -> a != b end)
    end)
  end

  def subfact(0), do: 1
  def subfact(1), do: 0
  def subfact(n), do: (n-1) * (subfact(n-1) + subfact(n-2))

  def permutation([]), do: [[]]
  def permutation(list) do
    for x <- list, y <- permutation(list -- [x]), do: [x|y]
  end
end

IO.puts "derangements for n = 4"
Enum.each(Permutation.derangements(4), &IO.inspect &1)

IO.puts "\nNumber of derangements"
IO.puts " n    derange   subfact"
Enum.each(0..9, fn n ->
  :io.format "~2w :~9w,~9w~n", [n, length(Permutation.derangements(n)), Permutation.subfact(n)]
end)
Enum.each(10..20, fn n ->
  :io.format "~2w :~19w~n", [n, Permutation.subfact(n)]
end)
