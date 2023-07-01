-- Handle multiple occurrences of a string for part 2
on offset of needle in haystack
	local needle, haystack
	
	if the needle is not in the haystack then return {}
	set my text item delimiters to the needle
	script
		property N : needle's length
		property t : {1 - N} & haystack's text items
	end script
	
	tell the result
		repeat with i from 2 to (its t's length) - 1
			set x to item i of its t
			set y to item (i - 1) of its t
			set item i of its t to (its N) + (x's length) + y
		end repeat
		
		items 2 thru -2 of its t
	end tell
end offset

offset of "happy" in stringA --> {8, 44, 83, 110}
