justtwounique(w) = unique(filter(c -> count(==(c), w) == 2, w))

function justtwos(arr)
	ret = [Char[] for _ in arr]
	for (i, w) in enumerate(arr), c in justtwounique(w)
		!any(c in w2 for w2 in arr if w2 != w) && push!(ret[i], c)
	end
	return ret
end

countthosewith(arr) = map(length, justtwos(arr))
countthosewithout(arr) = length.(unique.(arr)) .- countthosewith(arr)

a = ["ahwiueshaiu", "ajxxfioaaf", "ajrdsfroiwr"]

@show justtwos(a)
@show countthosewith(a)
@show countthosewithout(a)
