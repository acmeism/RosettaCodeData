function shuffle( a )
	dim i
	dim r
	randomize timer
	for i = lbound( a ) to ubound( a )
		r = int( rnd * ( ubound( a ) + 1 )  )
		if r <> i then
			swap a(i), a(r)
		end if
	next
	shuffle = a
end function

sub swap( byref a, byref b )
	dim tmp
	tmp = a
	a = b
	b = tmp
end sub
