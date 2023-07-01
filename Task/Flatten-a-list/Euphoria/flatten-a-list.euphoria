sequence a = {{1}, 2, {{3, 4}, 5}, {{{}}}, {{{6}}}, 7, 8, {}}

function flatten( object s )
	sequence res = {}
	if sequence( s ) then
		for i = 1 to length( s ) do
			sequence c = flatten( s[ i ] )
			if length( c ) > 0 then
				res &= c
			end if
		end for
	else
		if length( s ) > 0 then
			res = { s }
		end if
	end if
	return res
end function

? a
? flatten(a)
