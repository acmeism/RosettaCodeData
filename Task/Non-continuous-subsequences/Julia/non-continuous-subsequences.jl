using Printf, IterTools

import Base.IteratorSize, Base.iterate, Base.length

iscontseq(n::Integer) = count_zeros(n) == leading_zeros(n) + trailing_zeros(n)
iscontseq(n::BigInt)  = !ismatch(r"0", rstrip(bin(n), '0'))

function makeint2seq(n::Integer)
    idex = collect(1:n)
    function int2seq(m::Integer)
        d = digits(m, base=2, pad=n)
        idex[d .== 1]
    end
    return int2seq
end

struct NCSubSeq{T<:Integer}
    n::T
end

mutable struct NCSubState{T<:Integer}
    m::T
    m2s::Function
end

Base.IteratorSize(::NCSubSeq) = Base.HasLength()
Base.length(a::NCSubSeq) = 2 ^ a.n - a.n * (a.n + 1) ÷ 2 - 1
function Base.iterate(a::NCSubSeq, as::NCSubState=NCSubState(5, makeint2seq(a.n)))
    if 2 ^ a.n - 3 < as.m
        return nothing
    end
    s = as.m2s(as.m)
    as.m += 1
    while iscontseq(as.m)
        as.m += 1
    end
    return (s, as)
end

n = 4
println("Testing NCSubSeq for ", n, " items:\n ", join(NCSubSeq(n), " "))

s = "Rosetta"
cs = split(s, "")
m = 10
n = length(NCSubSeq(length(cs))) - m
println("\nThe first and last ", m, " NC sub-sequences of \"", s, "\":")
for (i, a) in enumerate(NCSubSeq(length(s)))
    i <= m || n < i || continue
    println(@sprintf "%6d %s" i join(cs[a], ""))
    i == m || continue
    println("    .. ......")
end

println("\nThe first and last ", m, " NC sub-sequences of \"", s, "\"")
for x in IterTools.Iterators.flatten([1:10; 20:10:40; big.(50:50:200)])
    @printf "%7d → %d\n" x length(NCSubSeq(x))
end
