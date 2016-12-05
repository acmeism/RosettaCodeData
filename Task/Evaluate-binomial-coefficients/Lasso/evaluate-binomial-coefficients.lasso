define binomial(n::integer,k::integer) => {
	#k == 0 ? return 1
	local(result = 1)
	loop(#k) => {
		#result = #result * (#n - loop_count + 1) / loop_count
	}
	return #result
}
// Tests
binomial(5, 3)
binomial(5, 4)
binomial(60, 30)
