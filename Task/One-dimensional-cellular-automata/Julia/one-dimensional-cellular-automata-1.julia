automaton(g::Vector{Bool}) =
    for i ∈ 0:9
    	println(join(alive ? '#' : '_' for alive ∈ g))
	    g = ([false; g[1:end-1]] .+ g .+ [g[2:end]; false]) .== 2
    end

automaton([c == '#' for c ∈ "_###_##_#_#_#_#__#__"])
