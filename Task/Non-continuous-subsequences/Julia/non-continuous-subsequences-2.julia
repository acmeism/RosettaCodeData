n = 4
print("Testing NCSubSeq for ", n, " items:\n   ")
for a in NCSubSeq(n)
    print(" ", a)
end
println()

s = "Rosetta"
cs = split(s, "")
m = 10
n = length(NCSubSeq(length(s))) - m
println()
println("The first and last ", m, " NC sub-sequences of \"", s, "\":")
for (i,a) in enumerate(NCSubSeq(length(cs)))
    i <= m || n < i || continue
    println(@sprintf "%6d %s" i join(cs[a], ""))
    i == m || continue
    println("    .. ......")
end

t = {}
append!(t, collect(1:10))
append!(t, collect(20:10:40))
append!(t, big(50):50:200)
println()
println("Numbers of NC sub-sequences of a given length:")
for i in t
    println(@sprintf("%7d => ", i), length(NCSubSeq(i)))
end
