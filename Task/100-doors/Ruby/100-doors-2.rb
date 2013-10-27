n = 100
Open = "open"
Closed = "closed"
def Open.toggle
  Closed
end
def Closed.toggle
  Open
end
doors = [Closed] * (n + 1)
for mul in 1..n
  for x in 1..n / mul
    doors[mul * x] = doors[mul * x].toggle
  end
end
doors.each_with_index { |b, i|
  puts "Door #{i} is #{b}" if i > 0
}
