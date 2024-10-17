p = Set(["A", "B"])
q = Set(["C", "D"])
r = Set(["B", "D"])
s = Set(["H", "I", "K"])
t = Set(["F", "G", "H"])

println("p = ", p)
println("q = ", q)
println("r = ", r)
println("s = ", s)
println("t = ", t)

println("consolidate([p, q]) =\n    ", consolidate([p, q]))
println("consolidate([p, r]) =\n    ", consolidate([p, r]))
println("consolidate([p, q, r]) =\n    ", consolidate([p, q, r]))
println("consolidate([p, q, r, s, t]) =\n    ",
        consolidate([p, q, r, s, t]))
