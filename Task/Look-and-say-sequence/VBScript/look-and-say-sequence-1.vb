function looksay( n )
	dim i
	dim accum
	dim res
	dim c
	res = vbnullstring
	do
		if n = vbnullstring then exit do
		accum = 0
		c = left( n,1 )
		do while left( n, 1 ) = c
			accum = accum + 1
			n = mid(n,2)
		loop
		if accum > 0 then
			res = res & accum & c
		end if
	loop
	looksay = res
end function
