set x to linefeed
repeat with i from 1 to 5
	repeat with j from 1 to i
		set x to x & "*"
	end repeat
	set x to x & linefeed
end repeat
return x
