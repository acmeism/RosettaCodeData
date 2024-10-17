defmodule Sort do
  def bsort(list) when is_list(list) do
    t = bsort_iter(list)

    if t == list, do: t, else: bsort(t)
  end

  def bsort_iter([x, y | t]) when x > y, do: [y | bsort_iter([x | t])]
  def bsort_iter([x, y | t]), do: [x | bsort_iter([y | t])]
  def bsort_iter(list), do: list
end
