local list = {}
for i = 1, 1000 do
  list[i] = 1 + math.sqrt(-2 * math.log(math.random())) * math.cos(2 * math.pi * math.random()) / 2
end
