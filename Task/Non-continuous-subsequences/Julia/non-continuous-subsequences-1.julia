iscontseq(n::Integer) = count_zeros(n) == leading_zeros(n) + trailing_zeros(n)
iscontseq(n::BigInt) = !ismatch(r"0", rstrip(bin(n), '0'))

function makeint2seq(n::Integer)
    const idex = collect(1:n)
    function int2seq(m::Integer)
        d = digits(m, 2, n)
        idex[d .== 1]
    end
    return int2seq
end

immutable NCSubSeq{T<:Integer}
    n::T
end

type NCSubState{T<:Integer}
    m::T
    m2s::Function
end

Base.length(a::NCSubSeq) = 2^a.n - div(a.n*(a.n+1), 2) - 1
Base.start(a::NCSubSeq) = NCSubState(5, makeint2seq(a.n))
Base.done(a::NCSubSeq, as::NCSubState) = 2^a.n-3 < as.m

function Base.next(a::NCSubSeq, as::NCSubState)
    s = as.m2s(as.m)
    as.m += 1
    while iscontseq(as.m)
        as.m += 1
    end
    return (s, as)
end
