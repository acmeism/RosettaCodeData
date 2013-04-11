def a = new A()
a.y = 55
a.z = { println (new Date()); Thread.sleep 5000 }

println a.x(25)
println a.y
(0..2).each(a.z)

println a.q
