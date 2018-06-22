defmodule Sort do
  def qsort([]), do: []
  def qsort([h | t]) do
    {lesser, greater} = Enum.split_with(t, &(&1 < h))
    qsort(lesser) ++ [h] ++ qsort(greater)
  end
end
