function pancake(len)
    gap, gapsum, adj = 2, 2, -1
    while gapsum < len
        adj += 1
        gap = gap * 2 - 1
        gapsum += gap
    end
    return len + adj
end

for i in 1:25
    print("pancake(", lpad(i, 2), ") = ", rpad(pancake(i), 5))
    i % 5 == 0 && println()
end
