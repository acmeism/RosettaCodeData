defmodule Greatest do
  def subseq_sum(list) do
    limit = length(list) - 1
    ij = for i <- 0..limit, j <- i..limit, do: {i,j}
    Enum.reduce(ij, {0, []}, fn {i,j},{max, subseq} ->
      slice = Enum.slice(list, i..j)
      sum = Enum.sum(slice)
      if sum > max, do: {sum, slice}, else: {max, subseq}
    end)
  end
end
