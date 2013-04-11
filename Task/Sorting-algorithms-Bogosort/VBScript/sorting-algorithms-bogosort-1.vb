sub swap( byref a, byref b )
	dim tmp
	tmp = a
	a = b
	b = tmp
end sub

'knuth shuffle (I think)
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

function inOrder( a )
	dim res
	dim i
	for i = 0 to ubound( a ) - 1
		res = ( a(i) <= a(i+1) )
		if res = false then exit for
	next
	inOrder = res
end function
