function Squish( s1 )
	dim sRes
	sRes = vbNullString
	dim i, c
	for i = 1 to len( s1 )
		c = lcase( mid( s1, i, 1 ))
		if instr( "abcdefghijklmnopqrstuvwxyz0123456789", c ) then
			sRes = sRes & c
		end if
	next
	Squish = sRes
end function
		
function isPalindrome( s1 )
	dim squished
	squished = Squish( s1 )
	isPalindrome = ( squished = StrReverse( squished ) )
end function
