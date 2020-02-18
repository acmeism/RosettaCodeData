julia> Pkg.add("CellularAutomata")
INFO: Installing CellularAutomata v0.1.2
INFO: Package database updated

julia> using CellularAutomata

julia> gameOfLife{T<:Int}(n::T, m::T, gen::T) = CA2d([3], [2,3], int(randbool(n, m)), gen)
gameOfLife (generic function with 1 method)

julia> gameOfLife(15, 30, 5)
30x15x5 Cellular Automaton
