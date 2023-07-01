function ethmult2(a::Integer, b::Integer)
    A = [a]
    B = [b]
    while A[end] > 1
        push!(A, halve(A[end]))
        push!(B, double(B[end]))
    end
    return sum(B[map(!even, A)])
end

@show ethmult2(17, 34)
