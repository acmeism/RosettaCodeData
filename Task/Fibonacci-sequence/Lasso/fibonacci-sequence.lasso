define fibonacci(n::integer) => {

	#n < 1 ? return false

	local(
		swap	= 0,
		n1		= 0,
		n2		= 1
	)

	loop(#n) => {
        #swap = #n1 + #n2;
        #n2 = #n1;
        #n1 = #swap;
	}
	return #n1

}

fibonacci(0) //->output false
fibonacci(1) //->output 1
fibonacci(2) //->output 1
fibonacci(3) //->output 2
