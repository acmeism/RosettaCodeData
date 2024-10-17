function cocktailsort(a::Vector)
    b = copy(a)
    isordered = false
    lo, hi = 1, length(b)
    while !isordered && hi > lo
        isordered = true
        for i in lo+1:hi
            if b[i] < b[i-1]
                b[i-1], b[i] = b[i], b[i-1]
                isordered = false
            end
        end
        hi -= 1
        if isordered || hi ≤ lo break end
        for i in hi:-1:lo+1
            if b[i-1] > b[i]
                b[i-1], b[i] = b[i], b[i-1]
                isordered = false
            end
        end
        lo += 1
    end
    return b
end

v = rand(-10:10, 10)
println("# unordered: $v\n -> ordered: ", cocktailsort(v))
