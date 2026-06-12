function pollards_rho(number::Integer)
	iseven(number) && return 2
	bit_length = ndigits(number, base=2)
	x, constant = rand(0:2^(bit_length-1), 2)
	y = x
	divisor = 1
	while divisor == 1
        x = ( x * x + constant ) % number
	    y = ( y * y + constant ) % number
	    y = ( y * y + constant ) % number
	    divisor = gcd(x - y, number)
	end
	return divisor;
end

 const tests = [ 4294967213, 9759463979, 34225158206557151, 13 ]

for test in tests
	divisor_one = pollards_rho(test)
    divisor_two = div(test,  divisor_one)
    @assert rem(test, divisor_one) == 0
	println(test, " = ", divisor_one, " * ", divisor_two)
end
