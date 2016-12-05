#!/usr/bin/lasso9

define cube(x::decimal) => {
	return #x -> pow(3.0)
}

define cuberoot(x::decimal) => {
	return #x -> pow(1.0/3.0)
}

define compose(f, g, v) => {
	return {
		return #f -> detach -> invoke(#g -> detach -> invoke(#1))
	} -> detach -> invoke(#v)
}


local(functions = array({return #1 -> sin}, {return #1 -> cos}, {return cube(#1)}))
local(inverse = array({return #1 -> asin}, {return #1 -> acos}, {return cuberoot(#1)}))

loop(3)
	stdoutnl(
		compose(
			#functions -> get(loop_count),
			#inverse -> get(loop_count),
			0.5
		)
	)

/loop
