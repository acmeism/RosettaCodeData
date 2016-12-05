defmodule Chinese do
  def remainder(mods, remainders) do
    max = Enum.reduce(mods, fn x,acc -> x*acc end)
    Enum.zip(mods, remainders)
    |> Enum.map(fn {m,r} -> Enum.take_every(r..max, m) |> MapSet.new end)
    |> Enum.reduce(fn set,acc -> MapSet.intersection(set, acc) end)
    |> MapSet.to_list
  end
end

IO.inspect Chinese.remainder([3,5,7], [2,3,2])
IO.inspect Chinese.remainder([10,4,9], [11,22,19])
IO.inspect Chinese.remainder([11,12,13], [10,4,12])
