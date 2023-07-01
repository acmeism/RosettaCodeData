defmodule Sort_disjoint do
  def sublist(values, indices) when is_list(values) and is_list(indices) do
    indices2 = Enum.sort(indices)
    selected = select(values, indices2, 0, []) |> Enum.sort
    replace(values, Enum.zip(indices2, selected), 0, [])
  end

  defp select(_, [], _, selected), do: selected
  defp select([val|t], [i|rest], i, selected), do: select(t, rest, i+1, [val|selected])
  defp select([_|t], indices, i, selected), do: select(t, indices, i+1, selected)

  defp replace(values, [], _, list), do: Enum.reverse(list, values)
  defp replace([_|t], [{i,v}|rest], i, list), do: replace(t, rest, i+1, [v|list])
  defp replace([val|t], indices, i, list), do: replace(t, indices, i+1, [val|list])
end

values = [7, 6, 5, 4, 3, 2, 1, 0]
indices = [6, 1, 7]
IO.inspect Sort_disjoint.sublist(values, indices)
