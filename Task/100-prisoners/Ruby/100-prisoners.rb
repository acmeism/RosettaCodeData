prisoners = [*1..100]
N = 10_000
generate_rooms = ->{ [nil]+[*1..100].shuffle }

res = N.times.count do
  rooms = generate_rooms[]
  prisoners.all? {|pr| rooms[1,100].sample(50).include?(pr)}
end
puts "Random strategy : %11.4f %%" % (res.fdiv(N) * 100)

res = N.times.count do
  rooms = generate_rooms[]
  prisoners.all? do |pr|
    cur_room = pr
    50.times.any? do
      found = (rooms[cur_room] == pr)
      cur_room = rooms[cur_room]
      found
    end
  end
end
puts "Optimal strategy: %11.4f %%" % (res.fdiv(N) * 100)
