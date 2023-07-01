defmodule Sort do
  def shell_sort(list) when length(list)<=1, do: list
  def shell_sort(list), do: shell_sort(list, div(length(list),2))

  defp shell_sort(list, inc) do
    gb = Enum.with_index(list) |> Enum.group_by(fn {_,i} -> rem(i,inc) end)
    wk = Enum.map(0..inc-1, fn i ->
           Enum.map(gb[i], fn {x,_} -> x end) |> insert_sort([])
         end)
         |> merge
    if sorted?(wk), do: wk, else: shell_sort( wk, max(trunc(inc / 2.2), 1) )
  end

  defp merge(lists) do
    len = length(hd(lists))
    Enum.map(lists, fn list -> if length(list)<len, do: list++[nil], else: list end)
    |> List.zip
    |> Enum.flat_map(fn tuple -> Tuple.to_list(tuple) end)
    |> Enum.filter(&(&1))               # remove nil
  end

  defp sorted?(list) do
    Enum.chunk(list,2,1) |> Enum.all?(fn [a,b] -> a <= b end)
  end

  defp insert_sort(list), do: insert_sort(list, [])

  defp insert_sort([], sorted), do: sorted
  defp insert_sort([h | t], sorted), do: insert_sort(t, insert(h, sorted))

  defp insert(x, []), do: [x]
  defp insert(x, sorted) when x < hd(sorted), do: [x | sorted]
  defp insert(x, [h | t]), do: [h | insert(x, t)]
end

list = [0, 14, 11, 8, 13, 15, 5, 7, 16, 17, 1, 6, 12, 2, 10, 4, 19, 9, 18, 3]
IO.inspect Sort.shell_sort(list)
