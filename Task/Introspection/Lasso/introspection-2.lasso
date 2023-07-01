var(
	bloob		= -26,
	positive	= 450
)

local(total = integer)

with v in var_keys
// Lasso creates a number of thread variables that all start with an underscore. We don't want those
where not(string(#v) -> beginswith('_')) and var(#v) -> isa(::integer)
do {
	#total += var(#v)
}

#total
