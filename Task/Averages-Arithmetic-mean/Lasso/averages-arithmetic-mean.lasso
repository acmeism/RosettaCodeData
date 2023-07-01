define average(a::array) => {
	not #a->size ? return 0
	local(x = 0.0)
	with i in #a do => { #x += #i }
	return #x / #a->size
}

average(array(1,2,5,17,7.4)) //6.48
