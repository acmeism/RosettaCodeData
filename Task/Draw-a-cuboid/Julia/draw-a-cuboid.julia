_pr(t::Dict, x::Int, y::Int, z::Int) = join((rstrip(join(t[(n, m)] for n in range(0, 3+x+z))) for m in reverse(range(0, 3+y+z))), "\n")

function cuboid(x::Int, y::Int, z::Int)
    t = Dict((n, m) => " " for n in range(0, 3 + x + z), m in range(0, 3 + y + z))
    xrow = vcat("+", collect("$(i % 10)" for i in range(0, x)), "+")
    for (i, ch) in enumerate(xrow) t[(i, 0)] = t[(i, 1+y)] = t[(1+z+i, 2+y+z)] = ch end
    yrow = vcat("+", collect("$(j % 10)" for j in range(0, y)), "+")
    for (j, ch) in enumerate(yrow) t[(0, j)] = t[(x+1, j)] = t[(2+x+z, 1+z+j)] = ch end
    zdep = vcat("+", collect("$(k % 10)" for k in range(0, y)), "+")
    for (k, ch) in enumerate(xrow) t[(k, 1+y+k)] = t[(1+x+k, 1+y+k)] = t[(1+x+k, k)] = ch end

    return _pr(t, x, y, z)
end

for (x, y, z) in [(2, 3, 4), (3, 4, 2), (4, 2, 3), (5, 5, 6)]
    println("\nCUBOID($x, $y, $z)\n")
    println(cuboid(x, y, z))
end
