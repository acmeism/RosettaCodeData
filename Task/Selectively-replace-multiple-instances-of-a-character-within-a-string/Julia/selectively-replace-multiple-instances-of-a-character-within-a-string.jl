rep = Dict('a' => Dict(1 => 'A', 2 => 'B', 4 => 'C', 5 => 'D'), 'b' => Dict(1 => 'E'), 'r' => Dict(2 => 'F'))

function trstring(oldstring, repdict)
    seen, newchars = Dict{Char, Int}(), Char[]
    for c in oldstring
        i = get!(seen, c, 1)
        push!(newchars, haskey(repdict, c) && haskey(repdict[c], i) ? repdict[c][i] : c)
        seen[c] += 1
    end
    return String(newchars)
end

println("abracadabra -> ", trstring("abracadabra", rep))
