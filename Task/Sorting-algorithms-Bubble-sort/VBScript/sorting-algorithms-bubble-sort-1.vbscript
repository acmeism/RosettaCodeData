sub decr( byref n )
	n = n - 1
end sub

sub incr( byref n )
	n = n + 1
end sub

sub swap( byref a, byref b)
	dim tmp
	tmp = a
	a = b
	b = tmp
end sub

function bubbleSort( a )
	dim changed
	dim itemCount
	itemCount = ubound(a)
	do
		changed = false
		decr itemCount
		for i = 0 to itemCount
			if a(i) > a(i+1) then
				swap a(i), a(i+1)
				changed = true
			end if
		next
	loop until not changed
	bubbleSort = a
end function
