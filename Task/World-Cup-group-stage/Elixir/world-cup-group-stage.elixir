defmodule World_Cup do
  def group_stage do
    results = [[3,0],[1,1],[0,3]]
    teams = [0,1,2,3]
    allresults = combos(2,teams) |> combinations(results)
    allpoints = for list <- allresults, do: (for {l1,l2} <- list, do: Enum.zip(l1,l2)) |> List.flatten
    totalpoints = for list <- allpoints, do: (for t <- teams, do: {t, Enum.sum(for {t_,points} <- list, t_==t, do: points)} )
    sortedtotalpoints = for list <- totalpoints, do: Enum.sort(list,fn({_,a},{_,b}) -> a > b end)
    pointsposition = for n <- teams, do: (for list <- sortedtotalpoints, do: elem(Enum.at(list,n),1))
    for n <- teams do
      for points <- 0..9 do
        Enum.at(pointsposition,n) |> Enum.filter(&(&1 == points)) |> length
      end
    end
  end

  defp combos(1, list), do: (for x <- list, do: [x])
  defp combos(k, list) when k == length(list), do: [list]
  defp combos(k, [h|t]) do
    (for subcombos <- combos(k-1, t), do: [h | subcombos]) ++ (combos(k, t))
  end

  defp combinations([h],list2), do: (for item <- list2, do: [{h,item}])
  defp combinations([h|t],list2) do
    for item <- list2, comb <- combinations(t,list2), do: [{h,item} | comb]
  end
end

format = String.duplicate("~4w", 10) <> "~n"
:io.format(format, Enum.to_list(0..9))
IO.puts String.duplicate(" ---", 10)
Enum.each(World_Cup.group_stage, fn x -> :io.format(format, x) end)
