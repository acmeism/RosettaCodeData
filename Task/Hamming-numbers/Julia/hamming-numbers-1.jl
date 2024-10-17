function hammingsequence(N)
    if N < 1
        throw("Hamming sequence exponent must be a positive integer")
    end
    ham = N > 4000 ? Vector{BigInt}([1]) : Vector{Int}([1])
    base2, base3, base5 = (1, 1, 1)
    for i in 1:N-1
        x = min(2ham[base2], 3ham[base3], 5ham[base5])
        push!(ham, x)
        if 2ham[base2] <= x
            base2 += 1
        end
        if 3ham[base3] <= x
            base3 += 1
        end
        if 5ham[base5] <= x
            base5 += 1
        end
    end
    ham
end

println(hammingsequence(20))
println(hammingsequence(1691)[end])
println(hammingsequence(1000000)[end])
