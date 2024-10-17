defmodule Sort do
  def gnome_sort([]), do: []
  def gnome_sort([h|t]), do: gnome_sort([h], t)

  defp gnome_sort(list, []), do: list
  defp gnome_sort([prev|p], [next|n]) when next > prev, do: gnome_sort(p, [next,prev|n])
  defp gnome_sort(p, [next|n]), do: gnome_sort([next|p], n)
end

IO.inspect Sort.gnome_sort([8,3,9,1,3,2,6])
