define sum_of_a_series(n::integer,k::integer) => {
	local(sum = 0)
	loop(-from=#k,-to=#n) => {
		#sum += 1.00/(math_pow(loop_count,2))
	}
	return #sum
}
sum_of_a_series(1000,1)
