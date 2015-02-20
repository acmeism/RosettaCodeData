set x to return
repeat with i from 1 to 5
	repeat with j from 1 to i
		set x to x & "*"
	end repeat
	set x to x & return
end repeat
return x
