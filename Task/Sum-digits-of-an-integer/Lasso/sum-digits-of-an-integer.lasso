define br => '<br />\n'

define sumdigits(int, base = 10) => {
	fail_if(#base < 2, -1, 'Base need to be at least 2')
	local(
		out		= integer,
		divmod
	)
	while(#int) => {
		 #divmod = #int -> div(#base)
		 #int = #divmod -> first
		 #out += #divmod -> second
	}
	return #out
}

sumdigits(1)
br
sumdigits(12345)
br
sumdigits(123045)
br
sumdigits(0xfe, 16)
br
sumdigits(0xf0e, 16)
