option explicit
'~ dim depth
function ack(m, n)
	'~ wscript.stdout.write depth & " "
	if m = 0 then
		'~ depth = depth + 1
		ack = n + 1
		'~ depth = depth - 1
	elseif m > 0 and n = 0 then
		'~ depth = depth + 1
		ack = ack(m - 1, 1)
		'~ depth = depth - 1
	'~ elseif m > 0 and n > 0 then
	else
		'~ depth = depth + 1
		ack = ack(m - 1, ack(m, n - 1))
		'~ depth = depth - 1
	end if
	
end function
