defmodule Sort do
  def counting_sort([]), do: []
  def counting_sort(list) do
    {min, max} = Enum.min_max(list)
    count = Tuple.duplicate(0, max - min + 1)
    counted = Enum.reduce(list, count, fn x,acc ->
      i = x - min
      put_elem(acc, i, elem(acc, i) + 1)
    end)
    Enum.flat_map(min..max, &List.duplicate(&1, elem(counted, &1 - min)))
  end
end

IO.inspect Sort.counting_sort([1,-2,-3,2,1,-5,5,5,4,5,9])
