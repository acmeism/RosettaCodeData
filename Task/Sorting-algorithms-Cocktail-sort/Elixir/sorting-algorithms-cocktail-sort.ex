defmodule Sort do
  def cocktail_sort(list) when is_list(list), do: cocktail_sort(list, [], [])

  defp cocktail_sort([], minlist, maxlist), do: Enum.reverse(minlist, maxlist)
  defp cocktail_sort([x], minlist, maxlist), do: Enum.reverse(minlist, [x | maxlist])
  defp cocktail_sort(list, minlist, maxlist) do
    {max, rev} = cocktail_max(list, [])
    {min, rest} = cocktail_min(rev, [])
    cocktail_sort(rest, [min | minlist], [max | maxlist])
  end

  defp cocktail_max([max], list), do: {max, list}
  defp cocktail_max([x,y | t], list) when x<y, do: cocktail_max([y | t], [x | list])
  defp cocktail_max([x,y | t], list)         , do: cocktail_max([x | t], [y | list])

  defp cocktail_min([min], list), do: {min, list}
  defp cocktail_min([x,y | t], list) when x>y, do: cocktail_min([y | t], [x | list])
  defp cocktail_min([x,y | t], list)         , do: cocktail_min([x | t], [y | list])
end

IO.inspect Sort.cocktail_sort([5,3,9,4,1,6,8,2,7])
