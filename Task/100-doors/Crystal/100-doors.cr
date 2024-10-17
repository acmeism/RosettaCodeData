doors = Array.new(100, false)

1.upto(100) do |i|
  i.step(by: i, to: 100) do |j|
    doors[j - 1] = !doors[j - 1]
  end
end

doors.each_with_index do |open, i|
  puts "Door #{i + 1} is #{open ? "open" : "closed"}"
end
