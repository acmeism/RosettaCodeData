define median_ext(a::array) => {
	#a->sort

	if(#a->size % 2) => {
		// odd numbered element array, pick middle
		return #a->get(#a->size / 2 + 1)

	else
		// even number elements in array
		return (#a->get(#a->size / 2) + #a->get(#a->size / 2 + 1)) / 2.0
	}
}

median_ext(array(3,2,7,6)) // 4.5
median_ext(array(3,2,9,7,6)) // 6
