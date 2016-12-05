defmodule RC do
  def queen(n, display \\ true) do
    solve(n, [], [], [], display)
  end

  defp solve(n, row, _, _, display) when n==length(row) do
    if display, do: print(n,row)
    1
  end
  defp solve(n, row, add_list, sub_list, display) do
    Enum.map(Enum.to_list(0..n-1) -- row, fn x ->
      add = x + length(row)             # \ diagonal check
      sub = x - length(row)             # / diagonal check
      if (add in add_list) or (sub in sub_list) do
        0
      else
        solve(n, [x|row], [add | add_list], [sub | sub_list], display)
      end
    end) |> Enum.sum                    # total of the solution
  end

  defp print(n, row) do
    IO.puts frame = "+" <> String.duplicate("-", 2*n+1) <> "+"
    Enum.each(row, fn x ->
      line = Enum.map_join(0..n-1, fn i -> if x==i, do: "Q ", else: ". " end)
      IO.puts "| #{line}|"
    end)
    IO.puts frame
  end
end

Enum.each(1..6, fn n ->
  IO.puts " #{n} Queen : #{RC.queen(n)}"
end)

Enum.each(7..12, fn n ->
  IO.puts " #{n} Queen : #{RC.queen(n, false)}"             # no display
end)
