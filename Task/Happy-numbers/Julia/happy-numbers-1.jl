function happy(x)
	happy_ints = Int[]
	int_try = 1
	while length(happy_ints) < x
		n = int_try
		past = Int[]
		while n != 1
	    	n = sum(y^2 for y in digits(n))
        	n in past && break
            push!(past, n)
	    end
		n == 1 && push!(happy_ints,int_try)
		int_try += 1
	end
	return happy_ints
end
