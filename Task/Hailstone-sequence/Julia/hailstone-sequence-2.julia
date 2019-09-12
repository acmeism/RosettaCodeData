struct HailstoneSeq{T<:Integer}
    count::T
end

Base.eltype(::HailstoneSeq{T}) where T = T

function Base.iterate(h::HailstoneSeq, state=h.count)
    if state == 1
        (1, 0)
    elseif state < 1
        nothing
    elseif iseven(state)
        (state, state ÷ 2)
    elseif isodd(state)
        (state, 3state + 1)
    end
end

function Base.length(h::HailstoneSeq)
    len = 0
    for _ in h
        len += 1
    end
    return len
end

function Base.show(io::IO, h::HailstoneSeq)
    f5 = collect(Iterators.take(h, 5))
    print(io, "HailstoneSeq{", join(f5, ", "), "...}")
end

hs = HailstoneSeq(27)
println("Collection of the Hailstone sequence from 27: $hs")
cl = collect(hs)
println("First 5 elements: ", join(cl[1:5], ", "))
println("Last 5 elements: ", join(cl[end-4:end], ", "))

Base.isless(h::HailstoneSeq, s::HailstoneSeq) = length(h) < length(s)
println("The number with the longest sequence under 100,000 is: ", maximum(HailstoneSeq.(1:100_000)))
