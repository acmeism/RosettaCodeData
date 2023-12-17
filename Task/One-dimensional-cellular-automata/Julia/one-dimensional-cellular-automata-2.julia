struct Automaton g₀::Vector{Bool} end

Base.iterate(a::Automaton, g = a.g₀) =
    g, ([false; g[1:end-1]] .+ g .+ [g[2:end]; false]) .== 2

Base.show(io::IO, a::Automaton) = for g in Iterators.take(a, 10)
    println(io, join(alive ? '#' : '_' for alive ∈ g)) end

Automaton([c == '#' for c ∈ "_###_##_#_#_#_#__#__"])
