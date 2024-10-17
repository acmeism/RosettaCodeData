using Printf

function magicsquaredoubleeven(order::Int)
    if order % 4 != 0; error("the order must be divisible by 4") end

    sqr = Matrix{Int}(order, order)
    mul = div(order, 4)
    ext = vcat(1:mul, order-mul+1:order)
    isext(i::Int, j::Int) = (i in ext) == (j in ext)
    boolsqr = collect(isext(i, j) for i in 1:order, j in 1:order)
    for i in linearindices(sqr)
        if boolsqr[i]; sqr[i] = i end
        if !boolsqr[end+1-i]; sqr[end+1-i] = i end
    end
    return sqr
end

for n in (4, 8, 12)
    magicconst = div(n ^ 3 + n, 2)
    sq = magicsquaredoubleeven(n)

    println("Order: $n; magic constant: $magicconst.\nSquare:")
    for r in 1:n, c in 1:n
        @printf("%4i", sq[r, c])
        if c == n; println() end
    end
    println()
end
