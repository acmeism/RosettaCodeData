using Printf

function pennysgame(slen = 3)
	autobet() = rand(Bool, slen)
	function autobet(ob::BitArray{1})
		rlen = length(ob)
		2 < rlen || return ~ob
		3 < rlen || return [~ob[2]; ob[1:2]]
		opt = falses(rlen)
		opt[1] = true
		opt[(end-1):end] .= true
		ob != opt || return ~opt
		return opt
	end
	autobet(ob::Array{Bool, 1}) = autobet(convert(BitArray{1}, ob))

	function pgencode(a::AbstractString)
		b = uppercase(a)
		0 < length(b) || return trues(0)
		!occursin(r"[^HT]+", b) || error(@sprintf "%s is not a HT sequence" a)
		b = split(b, "")
		b .== "H"
	end
	pgdecode(a::AbstractArray{Bool}) = join([i ? "H" : "T" for i in a], "")

	function humanbet()
		b = ""
		while length(b) != slen || occursin(r"[^HT]+", b)
			print("Your bet? ")
			b = uppercase(chomp(readline()))
		end
		return b
	end

	println("Playing Penney's Game Against the computer.")

	if rand(Bool)
		mach = autobet()
		println(@sprintf "The computer bet first, choosing %s." pgdecode(mach))
		println("Now you can bet.")
		human = pgencode(humanbet())
	else
		println("You bet first.")
		human = pgencode(humanbet())
		mach = autobet(human)
	end
	print(@sprintf "You bet %s " pgdecode(human))
	println(@sprintf "and the computer bet %s." pgdecode(mach))
	pg = rand(Bool, slen)
	pgtail = copy(pg)
	while pgtail != mach && pgtail != human
		push!(pg, rand(Bool))
		pgtail = [pgtail[2:end]; pg[end]]
	end

	println(@sprintf("This game lasted %d turns yielding\n    %s",
		length(pg), pgdecode(pg)))
	if human == mach
		println("so you and the computer tied.")
	elseif pgtail == mach
		println("so the computer won.")
	else
		println("so you won.")
	end
end

pennysgame()
