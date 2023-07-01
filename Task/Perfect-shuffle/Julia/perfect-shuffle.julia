using Printf

function perfect_shuffle(a::Array)::Array
    if isodd(length(a)) error("cannot perform perfect shuffle on odd-length array") end

    rst = zeros(a)
    mid = div(length(a), 2)
    for i in 1:mid
        rst[2i-1], rst[2i] = a[i], a[mid+i]
    end
    return rst
end

function count_perfect_shuffles(decksize::Int)::Int
    a = collect(1:decksize)
    b, c = perfect_shuffle(a), 1
    while a != b
        b = perfect_shuffle(b)
        c += 1
    end
    return c
end

println("    Deck  n.Shuffles")
for i in (8, 24, 52, 100, 1020, 1024, 10000, 100000)
    count = count_perfect_shuffles(i)
    @printf("%7i%7i\n", i, count)
end
