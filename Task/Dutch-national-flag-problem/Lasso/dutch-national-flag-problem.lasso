define orderdutchflag(a) => {
	local(r = array, w = array, b = array)
	with i in #a do => {
		match(#i) => {
			case('Red')
				#r->insert(#i)
			case('White')
				#w->insert(#i)
			case('Blue')
				#b->insert(#i)
		}
	}
	return #r + #w + #b
}

orderdutchflag(array('Red', 'Red', 'Blue', 'Blue', 'Blue', 'Red', 'Red', 'Red', 'White', 'Blue'))
