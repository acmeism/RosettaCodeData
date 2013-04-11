function cocktailSort( a )
	dim swapped
	dim i
	do
		swapped = false
		for i = 0 to ubound( a )  - 1
			if a(i) > a(i+1) then
				swap a(i), a(i+1)
				swapped = true
			end if
		next
		if not swapped then exit do
		swapped = false
		for i = ubound( a ) - 1 to 0 step -1
			if a(i) > a( i+1) then
				swap a(i), a(i+1)
				swapped = true
			end if
		next
		if not swapped then exit do
	loop
	cocktailSort = a
end function

sub swap( byref a, byref b)
	dim tmp
	tmp = a
	a = b
	b = tmp
end sub
