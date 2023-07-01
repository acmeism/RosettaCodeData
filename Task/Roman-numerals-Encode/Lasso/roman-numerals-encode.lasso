define br => '\r'
// encode roman
define encodeRoman(num::integer)::string => {
	local(ref = array('M'=1000, 'CM'=900, 'D'=500, 'CD'=400, 'C'=100, 'XC'=90, 'L'=50, 'XL'=40, 'X'=10, 'IX'=9, 'V'=5, 'IV'=4, 'I'=1))
	local(out = string)
	with i in #ref do => {
		while(#num >= #i->second) => {
			#out->append(#i->first)
			#num -= #i->second
		}
	}
	return #out
}

'1990 in roman is '+encodeRoman(1990)
br
'2008 in roman is '+encodeRoman(2008)
br
'1666 in roman is '+encodeRoman(1666)
