struct HailstoneSeq{T<:Integer}
	start::T
end

Base.eltype(::HailstoneSeq{T}) where T = T

Base.start(hs::HailstoneSeq) = (-1, hs.start)
Base.done(::HailstoneSeq, state) = state == (1, 4)
function Base.next(::HailstoneSeq, state)
	_, s2 = state
	s1 = s2
	if iseven(s2)
		s2 = s2 ÷ 2
	else
		s2 = 3s2 + 1
	end
	return s1, (s1, s2)
end

function Base.length(hs::HailstoneSeq)
	r = 0
	for _ in hs
		r += 1
	end
	return r
end

function Base.show(io::IO, hs::HailstoneSeq)
	f5 = collect(Iterators.take(hs, 5))
	print(io, "HailstoneSeq(", join(f5, ", "), "...)")
end

hs = HailstoneSeq(27)
println("Collection of the Hailstone sequence from 27: $hs")
cl = collect(hs)
println("First 5 elements: ", join(cl[1:5], ", "))
println("Last 5 elements: ", join(cl[end-4:end], ", "))

Base.isless(h::HailstoneSeq, s::HailstoneSeq) = length(h) < length(s)
println("The number with the longest sequence under 100,000 is: ", maximum(HailstoneSeq.(1:100_000)))
