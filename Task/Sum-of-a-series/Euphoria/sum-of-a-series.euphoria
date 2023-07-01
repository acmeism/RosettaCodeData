function s( atom x )
	return 1 / power( x, 2 )
end function

function sum( atom low, atom high )
	atom ret = 0.0
	for i = low to high do
		ret = ret + s( i )
	end for
	return ret
end function

printf( 1, "%.15f\n", sum( 1, 1000 ) )
