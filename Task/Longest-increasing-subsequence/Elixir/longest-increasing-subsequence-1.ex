defmodule Longest_increasing_subsequence do
  # Naive implementation
  def lis(l) do
    (for ss <- combos(l), ss == Enum.sort(ss), do: ss)
    |> Enum.max_by(fn ss -> length(ss) end)
  end

  defp combos(l) do
    Enum.reduce(1..length(l), [[]], fn k, acc -> acc ++ (combos(k, l)) end)
  end
  defp combos(1, l), do: (for x <- l, do: [x])
  defp combos(k, l) when k == length(l), do: [l]
  defp combos(k, [h|t]) do
    (for subcombos <- combos(k-1, t), do: [h | subcombos]) ++ combos(k, t)
  end
end

IO.inspect Longest_increasing_subsequence.lis([3,2,6,4,5,1])
IO.inspect Longest_increasing_subsequence.lis([0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15])
