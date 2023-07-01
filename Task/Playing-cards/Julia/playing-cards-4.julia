d = fresh(pokerlayout())
println("A new poker deck:")
println(pretty(d))

shuffle!(d)
println()
println("The deck shuffled:")
println(pretty(d))

n = 4
println()
println("Deal ", n, " hands:")
for i in 1:n
    h = deal!(d)
    println(pretty(h))
end

println()
println("And now the deck contains:")
println(pretty(d))
