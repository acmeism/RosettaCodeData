my text_between("Hello Rosetta Code world", "Hello ", " world")

on text_between(this_text, start_text, end_text)
	set return_text to ""
	try
		if (start_text is not "start") then
			set AppleScript's text item delimiters to start_text
			set return_text to text items 2 thru end of this_text as string
		else
			set return_text to this_text
		end if
		if (end_text is not "end") then
			set AppleScript's text item delimiters to end_text
			set return_text to text item 1 of return_text as string
			set AppleScript's text item delimiters to ""
		end if
	end try
	set AppleScript's text item delimiters to ""
	
	return return_text
end text_between
