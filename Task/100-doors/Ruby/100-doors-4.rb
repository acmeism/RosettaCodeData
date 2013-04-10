doors = [false] * 100
100.times do |i|
  (i .. doors.length).step(i+1) do |j|
    doors[j] = !doors[j]
  end
end
puts doors.inspect
