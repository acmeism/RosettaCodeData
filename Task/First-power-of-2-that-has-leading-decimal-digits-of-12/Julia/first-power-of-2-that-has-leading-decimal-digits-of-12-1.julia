function p(L, n)
    @assert(L > 0 && n > 0)
    places, logof2, nfound = trunc(log(10, L)), log(10, 2), 0
    for i in 1:typemax(Int)
        if L == trunc(10^(((i * logof2) % 1) + places)) && (nfound += 1) == n
            return i
        end
    end
end

for (L, n) in [(12, 1), (12, 2), (123, 45), (123, 12345), (123, 678910)]
    println("With L = $L and n = $n, p(L, n) = ", p(L, n))
end
