function gnomeSort( a )
	dim i
	dim j
	i = 1
	j = 2
	do while i < ubound( a ) + 1
		if a(i-1) <= a(i) then
			i = j
			j = j + 1
		else
			swap a(i-1), a(i)
			i = i - 1
			if i = 0 then
				i = j
				j = j + 1
			end if
		end if
	loop
	gnomeSort = a
end function

sub swap( byref x, byref y )
	dim temp
	temp = x
	x = y
	y = temp
end sub
