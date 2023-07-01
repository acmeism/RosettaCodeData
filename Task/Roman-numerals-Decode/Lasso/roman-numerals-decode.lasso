define br => '\r'
//decode roman
define decodeRoman(roman::string)::integer => {
	local(ref = array('M'=1000, 'CM'=900, 'D'=500, 'CD'=400, 'C'=100, 'XC'=90, 'L'=50, 'XL'=40, 'X'=10, 'IX'=9, 'V'=5, 'IV'=4, 'I'=1))
	local(out = integer)
	while(#roman->size) => {
		// need to use neset while instead of query expr to utilize loop_abort
		while(loop_count <= #ref->size) => {
			if(#roman->beginswith(#ref->get(loop_count)->first)) => {
				#out += #ref->get(loop_count)->second
				#roman->remove(1,#ref->get(loop_count)->first->size)
				loop_abort
			}
		}
	}
	return #out
}

'MCMXC as integer is '+decodeRoman('MCMXC')
br
'MMVIII as integer is '+decodeRoman('MMVIII')
br
'MDCLXVI as integer is '+decodeRoman('MDCLXVI')
