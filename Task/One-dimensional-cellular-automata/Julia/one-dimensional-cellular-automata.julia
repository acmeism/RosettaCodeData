function next_gen(a::BitArray{1}, isperiodic=false)
    b = copy(a)
    if isperiodic
        ncnt = prepend!(a[1:end-1], [a[end]]) + append!(a[2:end], [a[1]])
    else
        ncnt = prepend!(a[1:end-1], [false]) + append!(a[2:end], [false])
    end
    b[ncnt .== 0] = false
    b[ncnt .== 2] = ~b[ncnt .== 2]
    return b
end

function show_gen(a::BitArray{1})
    s = join([i ? "\u2588" : " " for i in a], "")
    s = "\u25ba"*s*"\u25c4"
end

hi = 70
a = bitrand(hi)
b = falses(hi)
println("A 1D Cellular Atomaton with ", hi, " cells and empty bounds.")
while any(a) && any(a .!= b)
    println("    ", show_gen(a))
    b = copy(a)
    a = next_gen(a)
end
a = bitrand(hi)
b = falses(hi)
println()
println("A 1D Cellular Atomaton with ", hi, " cells and periodic bounds.")
while any(a) && any(a .!= b)
    println("    ", show_gen(a))
    b = copy(a)
    a = next_gen(a, true)
end
