defmodule HundredDoors do
  def doors(n \\ 100) do
    List.duplicate(false, n)
  end

  def toggle(doors, n) do
    List.update_at(doors, n, &(!&1))
  end

  def toggle_every(doors, n) do
    Enum.reduce( Enum.take_every((n-1)..99, n), doors, fn(n, acc) -> toggle(acc, n) end )
  end
end

# unoptimized
final_state = Enum.reduce(1..100, HundredDoors.doors, fn(n, acc) -> HundredDoors.toggle_every(acc, n) end)

open_doors = Enum.with_index(final_state)
             |> Enum.filter_map(fn {door,_} -> door end, fn {_,index} -> index+1 end)

IO.puts "All doors are closed except these: #{inspect open_doors}"


# optimized
final_state = Enum.reduce(1..10, HundredDoors.doors, fn(n, acc) -> HundredDoors.toggle(acc, n*n-1) end)

open_doors = Enum.with_index(final_state)
             |> Enum.filter_map(fn {door,_} -> door end, fn {_,index} -> index+1 end)

IO.puts "All doors are closed except these: #{inspect open_doors}"
