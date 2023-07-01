set table to {return}
repeat with i from 1 to 10
	if i < 5 or (i ≥ 6 and i < 10) then
		set end of table to i & ", "
	else if i = 5 or i = 10 then
		set end of table to i & return
	end if
end repeat
return table as string
