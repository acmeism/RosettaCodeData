defmodule Anagrams do
  def deranged(fname) do
    File.read!(fname)
    |> String.split
    |> Enum.map(fn word -> to_charlist(word) end)
    |> Enum.group_by(fn word -> Enum.sort(word) end)
    |> Enum.filter(fn {_,words} -> length(words) > 1 end)
    |> Enum.sort_by(fn {key,_} -> -length(key) end)
    |> Enum.find(fn {_,words} -> find_derangements(words) end)
  end

  defp find_derangements(words) do
    comb(words,2) |> Enum.find(fn [a,b] -> deranged?(a,b) end)
  end

  defp deranged?(a,b) do
    Enum.zip(a, b) |> Enum.all?(fn {chr_a,chr_b} -> chr_a != chr_b end)
  end

  defp comb(_, 0), do: [[]]
  defp comb([], _), do: []
  defp comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end

case Anagrams.deranged("/work/unixdict.txt") do
  {_, words} -> IO.puts "Longest derangement anagram: #{inspect words}"
  _          -> IO.puts "derangement anagram: nothing"
end
