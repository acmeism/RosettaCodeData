on fixedlength(x, max)
	if x < 0 then
		set pref to "-"
		set x to -x
	else
		set pref to ""
	end if
	set s to x as text
	set min to (length of s) + (length of pref)
	repeat max - min times
		set s to "0" & s
	end repeat
	return pref & s
end fixedlength

repeat with x in {7.125, -7.125, 77.125, 777.125}
	log fixedlength(x, 9)
end repeat
