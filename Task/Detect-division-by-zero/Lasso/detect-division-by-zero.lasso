define dividehandler(a,b) => {
	(
		#a->isNotA(::integer) && #a->isNotA(::decimal) ||
		#b->isNotA(::integer) && #b->isNotA(::decimal)
	) ? return 'Error: Please supply all params as integers or decimals'
	protect => {
		handle_error => { return 'Error: Divide by zero' }
		local(x = #a / #b)
		return #x
	}
}

dividehandler(1,0)
