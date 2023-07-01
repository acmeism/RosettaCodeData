local(
	array1	= array('a', 'b', 'c'),
	array2	= array(1, 2, 3),
	hash	= map
)

loop(#array1 -> size) => {
	#hash -> insert(#array1 -> get(loop_count) = #array2 -> get(loop_count))
}

#hash
