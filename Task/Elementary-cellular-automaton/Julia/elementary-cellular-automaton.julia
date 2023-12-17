struct Automaton
    g₀::Vector{Bool}
    rule::Function
    Automaton(n::Int) = new(
        [c == '#' for c ∈ ".........#........."],
        i -> isone.(digits(n; base = 2, pad = 8))[i])
end

Base.iterate(a::Automaton, g = a.g₀) =
    g, @. a.rule(4*[g[end];g[1:end-1]] + 2*g + [g[2:end];g[1]] + 1)

Base.show(io::IO, a::Automaton) =
    for g in Iterators.take(a, 10)
        println(io, join(c ? '#' : '.' for c ∈ g))
    end

for n ∈ [90, 30, 14]
    println("rule $n:")
    show(Automaton(n))
    println()
end
