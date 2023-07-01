defmodule RC do
  # Set approach
  def uniq1(list), do: MapSet.new(list) |> MapSet.to_list

  # Sort approach
  def uniq2(list), do: Enum.sort(list) |> Enum.dedup

  # Go through the list approach
  def uniq3(list), do: uniq3(list, [])

  defp uniq3([], res), do: Enum.reverse(res)
  defp uniq3([h|t], res) do
    if h in res, do: uniq3(t, res), else: uniq3(t, [h | res])
  end
end

num = 10000
max = div(num, 10)
list = for _ <- 1..num, do: :rand.uniform(max)
funs = [&Enum.uniq/1, &RC.uniq1/1, &RC.uniq2/1, &RC.uniq3/1]
Enum.each(funs, fn fun ->
  result = fun.([1,1,2,1,'redundant',1.0,[1,2,3],[1,2,3],'redundant',1.0])
  :timer.tc(fn ->
    Enum.each(1..100, fn _ -> fun.(list) end)
  end)
  |> fn{t,_} -> IO.puts "#{inspect fun}:\t#{t/1000000}\t#{inspect result}" end.()
end)
