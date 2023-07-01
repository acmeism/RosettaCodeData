function printcircle(lo::Integer, hi::Integer, ndots::Integer; pad::Integer = 2)
    canvas = falses(2hi + 1, 2hi + 1)
    i = 0
    while i < ndots
        x, y = rand(-hi:hi, 2)
        if lo ^ 2 - 1 < x ^ 2 + y ^ 2 < hi ^ 2 + 1
            canvas[x + hi + 1, y + hi + 1] = true
            i += 1
        end
    end
    # print
    for i in 1:(2hi + 1)
        row = map(j -> j ? "\u25cf " : "  ", canvas[i, :])
        println(" " ^ pad, join(row))
    end
    return canvas
end

printcircle(10, 15, 100)
