defmodule HundredPrisoners do
  def optimal_room(_, _, _, []), do: []
  def optimal_room(prisoner, current_room, rooms, [_ | tail]) do
    found = Enum.at(rooms, current_room - 1) == prisoner
    next_room = Enum.at(rooms, current_room - 1)
    [found] ++ optimal_room(prisoner, next_room, rooms, tail)
  end

  def optimal_search(prisoner, rooms) do
    Enum.any?(optimal_room(prisoner, prisoner, rooms, Enum.to_list(1..50)))
  end
end

prisoners = 1..100
n = 1..10_000
generate_rooms = fn -> Enum.shuffle(1..100) end

random_strategy = Enum.count(n,
  fn _ ->
  rooms = generate_rooms.()
  Enum.all?(prisoners, fn pr -> pr in (rooms |> Enum.take_random(50)) end)
end)

IO.puts "Random strategy: #{random_strategy} / #{n |> Range.size}"

optimal_strategy = Enum.count(n,
  fn _ ->
  rooms = generate_rooms.()
  Enum.all?(prisoners,
    fn pr -> HundredPrisoners.optimal_search(pr, rooms) end)
end)

IO.puts "Optimal strategy: #{optimal_strategy} / #{n |> Range.size}"
