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
  for x in (mul..n).step(mul)
    doors[x] = doors[x].toggle
  end
end
doors.each_with_index do |b, i|
  puts "Door #{i} is #{b}" if i > 0
end
