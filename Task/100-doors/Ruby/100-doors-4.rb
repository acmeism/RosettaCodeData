doors = [false] * 100
100.times do |i|
  (i ... doors.length).step(i + 1) do |j|
    doors[j] = !doors[j]
  end
end
puts doors.map.with_index{|d, i| "Door #{i+1} is #{d ? 'open' : 'closed'}."}
