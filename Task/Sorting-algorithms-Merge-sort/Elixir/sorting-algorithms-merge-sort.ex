defmodule Sort do
  def merge_sort(list) when length(list) <= 1, do: list
  def merge_sort(list) do
    {left, right} = Enum.split(list, div(length(list), 2))
    :lists.merge( merge_sort(left), merge_sort(right))
  end
end
