define cube(n::integer) => #n*#n*#n

local(
	mynumbers = array(1, 2, 3, 4, 5),
	mycube = array
)

#mynumbers -> foreach => {
	#mycube -> insert(cube(#1))
}

#mycube
