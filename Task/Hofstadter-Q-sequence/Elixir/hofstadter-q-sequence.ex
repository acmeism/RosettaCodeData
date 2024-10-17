defmodule Hofstadter do
  defp flip(v2, v1) when v1 > v2, do: 1
  defp flip(_v2, _v1), do: 0

  defp list_terms(max, n, acc), do: Enum.map_join(n..max, ", ", &acc[&1])

  defp hofstadter(n, n, acc, flips) do
    IO.puts "The first ten terms are: #{list_terms(10, 1, acc)}"
    IO.puts "The 1000'th term is #{acc[1000]}"
    IO.puts "Number of flips: #{flips}"
  end
  defp hofstadter(max, n, acc, flips) do
    qn1 = acc[n-1]
    qn = acc[n - qn1] + acc[n - acc[n-2]]
    hofstadter(max, n+1, Map.put(acc, n, qn), flips + flip(qn, qn1))
  end

  def main(max \\ 100_000) do
    acc = %{1 => 1, 2 => 1}
    hofstadter(max+1, 3, acc, 0)
  end
end

Hofstadter.main
