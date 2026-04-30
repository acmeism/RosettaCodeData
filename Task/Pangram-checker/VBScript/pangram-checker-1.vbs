function pangram( s )
	dim i
	dim sKey
	dim sChar
	dim nOffset
	sKey = "abcdefghijklmnopqrstuvwxyz"
	for i = 1 to len( s )
		sChar = lcase(mid(s,i,1))
		if sChar <> " "  then
			if instr(sKey, sChar) then
				nOffset = asc( sChar ) - asc("a")  + 1
				if nOffset > 1 then
					sKey = left(sKey, nOffset - 1) & " " & mid( sKey, nOffset + 1)
				else
					sKey = " " & mid( sKey, nOffset + 1)
				end if
			end if
		end if
	next
	pangram = ( ltrim(sKey) = vbnullstring )
end function

function eef( bCond, exp1, exp2 )
	if bCond then
		eef = exp1
	else
		eef = exp2
	end if
end function
