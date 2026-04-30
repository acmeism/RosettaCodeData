class flattener
	dim separator
	
	sub class_initialize
		separator = ","
	end sub
	
	private function makeflat( a )
		dim i
		dim res
		for i = lbound( a ) to ubound( a )
			if isarray( a( i ) ) then
				res = res & makeflat( a( i ) )
			else
				res = res & a( i ) & separator
			end if
		next
		makeflat = res
	end function

	public function flatten( a )
		dim res
		res = makeflat( a )
		res = left( res, len( res ) - len(separator))
		res = split( res, separator )
		flatten = res
	end function
	
	public property let itemSeparator( c )
		separator = c
	end property
end class
