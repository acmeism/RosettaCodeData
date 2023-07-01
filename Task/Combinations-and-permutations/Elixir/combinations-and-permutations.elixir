defmodule Combinations_permutations do
  def perm(n, k), do: product(n - k + 1 .. n)

  def comb(n, k), do: div( perm(n, k), product(1 .. k) )

  defp product(a..b) when a>b, do: 1
  defp product(list), do: Enum.reduce(list, 1, fn n, acc -> n * acc end)

  def test do
    IO.puts "\nA sample of permutations from 1 to 12:"
    Enum.each(1..12, &show_perm(&1, div(&1, 3)))
    IO.puts "\nA sample of combinations from 10 to 60:"
    Enum.take_every(10..60, 10) |> Enum.each(&show_comb(&1, div(&1, 3)))
    IO.puts "\nA sample of permutations from 5 to 15000:"
    Enum.each([5,50,500,1000,5000,15000], &show_perm(&1, div(&1, 3)))
    IO.puts "\nA sample of combinations from 100 to 1000:"
    Enum.take_every(100..1000, 100) |> Enum.each(&show_comb(&1, div(&1, 3)))
  end

  defp show_perm(n, k), do: show_gen(n, k, "perm", &perm/2)

  defp show_comb(n, k), do: show_gen(n, k, "comb", &comb/2)

  defp show_gen(n, k, strfun, fun), do:
    IO.puts "#{strfun}(#{n}, #{k}) = #{show_big(fun.(n, k), 40)}"

  defp show_big(n, limit) do
    strn = to_string(n)
    if String.length(strn) < limit do
      strn
    else
      {shown, hidden} = String.split_at(strn, limit)
      "#{shown}... (#{String.length(hidden)} more digits)"
    end
  end
end

Combinations_permutations.test
