set s to text returned of (display dialog "Please input a word." default answer "")
set clist to characters of s
on charcount(c, l)
	set ccount to 0
	repeat with i from 1 to count of l
		if item i of l is c then
			set ccount to ccount + 1
		end if
	end repeat
	return ccount
end charcount
charcount("a", clist) = charcount("b", clist) and charcount("b", clist) = charcount("c", clist)
