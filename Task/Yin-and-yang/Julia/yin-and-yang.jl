function yinyang(n::Int=3)
    radii   = (i * n for i in (1, 3, 6))
    ranges  = collect(collect(-r:r) for r in radii)
    squares = collect(collect((x, y) for x in rnge, y in rnge) for rnge in ranges)
    circles = collect(collect((x, y) for (x,y) in sqrpoints if hypot(x, y) ≤ radius)
                      for (sqrpoints, radius) in zip(squares, radii))
    m = Dict((x, y) => ' ' for (x, y) in squares[end])
    for (x, y) in circles[end] m[(x, y)] = x > 0 ? '·' : '*' end
    for (x, y) in circles[end-1]
        m[(x, y + 3n)] = '*'
		m[(x, y - 3n)] = '·'
    end
    for (x, y) in circles[end-2]
        m[(x, y + 3n)] = '·'
		m[(x, y - 3n)] = '*'
    end
    return join((join(m[(x, y)]  for x in reverse(ranges[end])) for y in ranges[end]), '\n')
end

println(yinyang(4))
