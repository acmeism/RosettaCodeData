defmodule Sort do
  def insert_sort(list) when is_list(list), do: insert_sort(list, [])

  def insert_sort([], sorted), do: sorted
  def insert_sort([h | t], sorted), do: insert_sort(t, insert(h, sorted))

  defp insert(x, []), do: [x]
  defp insert(x, sorted) when x < hd(sorted), do: [x | sorted]
  defp insert(x, [h | t]), do: [h | insert(x, t)]
end
