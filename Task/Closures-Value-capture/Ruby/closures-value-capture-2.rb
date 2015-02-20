list = {}
for i in 1..10 do list[i] = proc {i * i} end
p list[3][]         #=> 100
i = 5
p list[3][]         #=> 25
