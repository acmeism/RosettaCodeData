prisoners = (1..100).to_a
N = 100_000
generate_rooms = ->{ (1..100).to_a.shuffle }

res = N.times.count do
  rooms = generate_rooms.call
  prisoners.all? { |pr| rooms[1, 100].sample(50).includes?(pr) }
end
puts "Random strategy : %11.4f %%" % (res.fdiv(N) * 100)

res = N.times.count do
  rooms = generate_rooms.call
  prisoners.all? do |pr|
    cur_room = pr
    50.times.any? do
      cur_room = rooms[cur_room - 1]
      found = (cur_room == pr)
      found
    end
  end
end
puts "Optimal strategy: %11.4f %%" % (res.fdiv(N) * 100)
