val o = 1 to 10 map (i => i * i)
println("open: " + o)
println("closed: " + (1 to 100 filterNot o.contains))
