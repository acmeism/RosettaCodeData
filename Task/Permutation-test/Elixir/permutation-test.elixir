defmodule Permutation do
  def statistic(ab, a) do
    sumab = Enum.sum(ab)
    suma  = Enum.sum(a)
    suma / length(a) - (sumab - suma) / (length(ab) - length(a))
  end

  def test(a, b) do
    ab = a ++ b
    tobs = statistic(ab, a)
    {under, count} = Enum.reduce(comb(ab, length(a)), {0,0}, fn perm, {under, count} ->
      if statistic(ab, perm) <= tobs, do: {under+1, count+1},
                                    else: {under  , count+1}
    end)
    under * 100.0 / count
  end

  defp comb(_, 0), do: [[]]
  defp comb([], _), do: []
  defp comb([h|t], m) do
    (for l <- comb(t, m-1), do: [h|l]) ++ comb(t, m)
  end
end

treatmentGroup = [85, 88, 75, 66, 25, 29, 83, 39, 97]
controlGroup   = [68, 41, 10, 49, 16, 65, 32, 92, 28, 98]
under = Permutation.test(treatmentGroup, controlGroup)
:io.fwrite "under = ~.2f%, over = ~.2f%~n", [under, 100-under]
