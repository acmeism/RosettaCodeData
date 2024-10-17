defmodule Ordered do
  def partition([]), do: [[]]
  def partition(mask) do
    sum = Enum.sum(mask)
    if sum == 0 do
      [Enum.map(mask, fn _ -> [] end)]
    else
      Enum.to_list(1..sum)
      |> permute
      |> Enum.reduce([], fn perm,acc ->
           {_, part} = Enum.reduce(mask, {perm,[]}, fn num,{pm,a} ->
             {p, rest} = Enum.split(pm, num)
             {rest, [Enum.sort(p) | a]}
           end)
           [Enum.reverse(part) | acc]
         end)
      |> Enum.uniq
    end
  end

  defp permute([]), do: [[]]
  defp permute(list), do: for x <- list, y <- permute(list -- [x]), do: [x|y]
end

Enum.each([[],[0,0,0],[1,1,1],[2,0,2]], fn test_case ->
  IO.puts "\npartitions #{inspect test_case}:"
  Enum.each(Ordered.partition(test_case), fn part ->
    IO.inspect part
  end)
end)
