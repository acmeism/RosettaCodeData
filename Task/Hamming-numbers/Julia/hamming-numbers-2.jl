function hammingsequence(N::Int)
    if N < 1
        throw("Hamming sequence index must be a positive integer")
    end
    ham = Vector{BigInt}([1])
    base2, base3, base5 = 1, 1, 1
    next2, next3, next5 = BigInt(2), BigInt(3), BigInt(5)
    for _ in 1:N-1
        x = min(next2, next3, next5)
        push!(ham, x)
        next2 <= x && (base2 += 1; next2 = 2ham[base2])
        next3 <= x && (base3 += 1; next3 = 3ham[base3])
        next5 <= x && (base5 += 1; next5 = 5ham[base5])
    end
    ham
end
