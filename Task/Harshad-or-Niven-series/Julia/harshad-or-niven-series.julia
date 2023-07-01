isharshad(x)   = x % sum(digits(x)) == 0
nextharshad(x) = begin while !isharshad(x+1) x += 1 end; return x + 1 end

function harshads(n::Integer)
	h = Vector{typeof(n)}(n)
	h[1] = 1
	for j in 2:n
		h[j] = nextharshad(h[j-1])
	end
	return h
end

println("First 20 harshad numbers: ", join(harshads(20), ", "))
println("First harshad number after 1001: ", nextharshad(1000))
