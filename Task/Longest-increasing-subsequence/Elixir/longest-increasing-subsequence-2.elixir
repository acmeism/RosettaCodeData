defmodule Longest_increasing_subsequence do
  # Patience sort implementation
  def patience_lis(l), do: patience_lis(l, [])

  defp patience_lis([h | t], []), do: patience_lis(t, [[{h,[]}]])
  defp patience_lis([h | t], stacks), do: patience_lis(t, place_in_stack(h, stacks, []))
  defp patience_lis([], []), do: []
  defp patience_lis([], stacks), do: get_previous(stacks) |> recover_lis |> Enum.reverse

  defp place_in_stack(e, [stack = [{h,_} | _] | tstacks], prevstacks) when h > e do
    prevstacks ++ [[{e, get_previous(prevstacks)} | stack] | tstacks]
  end
  defp place_in_stack(e, [stack | tstacks], prevstacks) do
    place_in_stack(e, tstacks, prevstacks ++ [stack])
  end
  defp place_in_stack(e, [], prevstacks) do
    prevstacks ++ [[{e, get_previous(prevstacks)}]]
  end

  defp get_previous(stack = [_|_]), do: hd(List.last(stack))
  defp get_previous([]), do: []

  defp recover_lis({e, prev}), do: [e | recover_lis(prev)]
  defp recover_lis([]), do: []
end

IO.inspect Longest_increasing_subsequence.patience_lis([3,2,6,4,5,1])
IO.inspect Longest_increasing_subsequence.patience_lis([0,8,4,12,2,10,6,14,1,9,5,13,3,11,7,15])
