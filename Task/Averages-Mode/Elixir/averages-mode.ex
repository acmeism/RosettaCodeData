defmodule Average do
  def mode(list) do
    gb = Enum.group_by(list, &(&1))
    max = Enum.map(gb, fn {_,val} -> length(val) end) |> Enum.max
    for {key,val} <- gb, length(val)==max, do: key
  end
end

lists = [[3,1,4,1,5,9,2,6,5,3,5,8,9],
         [1, 2, "qwe", "asd", 1, 2, "qwe", "asd", 2, "qwe"]]
Enum.each(lists, fn list ->
  IO.puts "mode: #{inspect list}"
  IO.puts "   => #{inspect Average.mode(list)}"
end)
