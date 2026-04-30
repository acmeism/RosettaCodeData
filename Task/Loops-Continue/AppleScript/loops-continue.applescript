set table to ""
repeat with i from 1 to 10
	repeat 1 times
		set table to table & i
		if i mod 5 = 0 then
			set table to table & return
			exit repeat
		end if
		set table to table & ", "
	end repeat
end repeat
return table
