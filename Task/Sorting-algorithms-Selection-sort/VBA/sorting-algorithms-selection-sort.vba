sub swap( byref a, byref b)
	dim tmp
	tmp = a
	a = b
	b = tmp
end sub

function selectionSort (a)
	for i = 0 to ubound(a)
	k = i
		for j=i+1 to ubound(a)
			if a(j) < a(i) then
				swap a(i), a(j)
			end if
		next
	next
	selectionSort = a
end function
