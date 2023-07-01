using Primes
using Printf

function primeAncestorsDecendants(maxsum)
	aprimes = primes(maxsum)
	ancestors = [Vector{Int}() for _ in 1:maxsum]
	descendants = [Vector{Int}() for _ in 1:maxsum]
	for p in aprimes
		push!(descendants[p], p)
		foreach(
			s -> append!(descendants[s + p], [p * pr for pr in descendants[s]]),
			2 : length(descendants)-p
		)
	end
	foreach(p -> pop!(descendants[p]), [aprimes..., 4])
	total = 0
	format(v::Vector{Int}) = join([dot(n) for n in v], ", ")
	dot(n::Int) = replace(string(n), r"(?<=[0-9])(?=(?:[0-9]{3})+(?![0-9]))" => ".")
	for s in 1:maxsum
		ance = [ancestors[s]..., s]
		desc = sort!(descendants[s]); total += dlen = length(desc)
		foreach(d-> ancestors[d] = ance,
			desc[1:(i-> i==nothing ? 0 : i)(findlast(e-> e<=maxsum, desc))]
		)
		(s in [0:20..., 46, 74, 99]) || continue
		ance = ancestors[s]; alen = length(ance)
		@printf("%3d: %1d ancestors %-17s %6s descendants %s\n"
			, s
			, alen, alen==0 ? "" : ance
			, dot(dlen), dlen==0 ? ""
				  : dlen<11 ? desc
				  : "[$(format(desc[1:5])), ..., $(format(desc[end-2:end]))]"
		)
	end
	print("\nTotal descendants: ", total)
end

primeAncestorsDecendants(99)
