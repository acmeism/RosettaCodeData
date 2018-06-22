function selfie(x::Integer)
	ds = reverse(digits(x))
	if sum(ds) != length(ds) return false end
	for (i, d) in enumerate(ds)
		if d != sum(ds .== i - 1) return false end
	end
	return true
end

@show selfie(2020)
@show selfie(2021)

selfies(x) = for i in 1:x selfie(i) && println(i) end
@time selfies(4000000)
