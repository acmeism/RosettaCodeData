defmodule Sort do
  def pancake_sort(list) when is_list(list), do: pancake_sort(list, length(list))

  defp pancake_sort(list, 0), do: list
  defp pancake_sort(list, limit) do
    index = search_max(list, limit)
    flip(list, index) |> flip(limit) |> pancake_sort(limit-1)
  end

  defp search_max([h | t], limit), do: search_max(t, limit, 2, h, 1)

  defp search_max(_, limit, index, _, max_index) when limit<index, do: max_index
  defp search_max([h | t], limit, index, max, max_index) do
    if h > max, do:   search_max(t, limit, index+1, h, index),
                else: search_max(t, limit, index+1, max, max_index)
  end

  defp flip(list, n), do: flip(list, n, [])

  defp flip(list, 0, reverse), do: reverse ++ list
  defp flip([h | t], n, reverse) do
    flip(t, n-1, [h | reverse])
  end
end

IO.inspect list = Enum.shuffle(1..9)
IO.inspect Sort.pancake_sort(list)
