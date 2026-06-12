on strrep(s, n)
	set r to ""
	repeat n times
		set r to r & s
	end repeat
	return r
end strrep

repeat with i from 0 to 7
	log (run script (strrep("1", i) & "3^2"))
end repeat
