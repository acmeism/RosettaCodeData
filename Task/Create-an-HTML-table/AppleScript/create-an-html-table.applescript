on pad_table(s, char2)
	set opener to "<t" & char2 & ">"
	set closer to "</t" & char2 & ">"
	repeat with i from 1 to length of s
		set x to item i of s
		set item i of s to opener & x & closer
	end repeat
	return "<tr>" & s & "</tr>"
end pad_table

on gen_row(n, ncols)
	set row to {n}
	repeat ncols times
		set row to row & (random number from 1 to 9999)
	end repeat
	return row
end gen_row

on html_table(headings, nrows)
	set ncols to length of headings
	set theader to pad_table({""} & headings, "h")
	set tbody to {}
	repeat with i from 1 to nrows
		set tbody to tbody & pad_table(gen_row(i, ncols), "d")
	end repeat
	set out to {"<table>"} & theader & tbody & {"</table>"}
	set AppleScript's text item delimiters to linefeed
	return out as text
end html_table

html_table({"X", "Y", "Z"}, 3)
