doors = falses(100)
for a in 1:100, b in a:a:100
    doors[b] = !doors[b]
end
for a = 1:100
    println("Door $a is " * (doors[a] ? "open." : "closed."))
end
