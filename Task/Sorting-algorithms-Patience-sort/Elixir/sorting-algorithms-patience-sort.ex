defmodule Sort do
  def patience_sort(list) do
    piles = deal_pile(list, [])
    merge_pile(piles, [])
  end

  defp deal_pile([], piles), do: piles
  defp deal_pile([h|t], piles) do
    index = Enum.find_index(piles, fn pile -> hd(pile) <= h end)
    new_piles = if index, do:   add_element(piles, index, h, []),
                          else: piles ++ [[h]]
    deal_pile(t, new_piles)
  end

  defp add_element([h|t], 0,     elm, work), do: Enum.reverse(work, [[elm | h] | t])
  defp add_element([h|t], index, elm, work), do: add_element(t, index-1, elm, [h | work])

  defp merge_pile([], list), do: list
  defp merge_pile(piles, list) do
    {max, index} = max_index(piles)
    merge_pile(delete_element(piles, index, []), [max | list])
  end

  defp max_index([h|t]), do: max_index(t, hd(h), 1, 0)

  defp max_index([], max, _, max_i), do: {max, max_i}
  defp max_index([h|t], max, index, _) when hd(h)>max, do: max_index(t, hd(h), index+1, index)
  defp max_index([_|t], max, index, max_i)           , do: max_index(t, max, index+1, max_i)

  defp delete_element([h|t], 0, work) when length(h)==1, do: Enum.reverse(work, t)
  defp delete_element([h|t], 0, work)                  , do: Enum.reverse(work, [tl(h) | t])
  defp delete_element([h|t], index, work), do: delete_element(t, index-1, [h | work])
end

IO.inspect Sort.patience_sort [4, 65, 2, -31, 0, 99, 83, 782, 1]
