on charcount(c, l)
	set ccount to 0
	repeat with i from 1 to count of l
		if item i of l is c then
			set ccount to ccount + 1
		end if
	end repeat
	return ccount
end charcount

repeat with n from 1 to 1000
	set clist to characters of (n as text)
	if charcount("1", clist) = 2 then log n
end repeat
