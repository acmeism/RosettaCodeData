define floyds_triangle(n::integer) => {
	local(out = array(array(1)),comp = array, num = 1)
	while(#out->size < #n) => {
		local(new = array)
		loop(#out->last->size + 1) => {
			#num++
			#new->insert(#num)
		}
		#out->insert(#new)
	}
	local(pad = #out->last->last->asString->size)
	with line in #out do => {
		local(lineout = string)
		with i in #line do => {
			#i != #line->first ? #lineout->append(' ')
			#lineout->append((' '*(#pad - #i->asString->size))+#i)
		}
		#comp->insert(#lineout)
	}
	return #comp->join('\r')
}
floyds_triangle(5)
'\r\r'
floyds_triangle(14)
