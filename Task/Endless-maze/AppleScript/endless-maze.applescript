set xp to 127
set yp to 127
set na to 0
set e to {}
set x to {}
set y to {}
set d to -1
set f to random number from 1 to 4
repeat while d is not 5
	set a to na + 1
	repeat with n from 1 to na
		if item n of x = xp and item n of y = yp then
			set a to n
			exit repeat
		end if
	end repeat
	if a = na + 1 then
		set na to na + 1
		set x to x & xp
		set y to y & yp
		repeat 4 times
			set e to e & some item of {true, false}
		end repeat
		repeat with n from 1 to na
			if item n of x = (item a of x) + 1 and item n of y = item a of y then
				set item (4 * (a - 1) + 1) of e to item (4 * (n - 1) + 3) of e
			end if
			if item n of x = item a of x and item n of y = (item a of y) + 1 then
				set (item (4 * (a - 1) + 2) of e) to item (4 * (n - 1) + 4) of e
			end if
			if item n of x = (item a of x) - 1 and item n of y = item a of y then
				set (item (4 * (a - 1) + 3) of e) to item (4 * (n - 1) + 1) of e
			end if
			if item n of x = item a of x and item n of y = (item a of y) - 1 then
				set (item (4 * (a - 1) + 4) of e) to item (4 * (n - 1) + 2) of e
			end if
		end repeat
	end if
	set pathlist to {}
	if item (4 * (a - 1) + f) of e then
		set pathlist to pathlist & "ahead "
	end if
	repeat with i from 1 to 3
		if item (1 + 4 * (a - 1) + ((f - 1 + i) mod 4)) of e then
			set pathlist to pathlist & item i of {"right ", "back ", "left "}
		end if
	end repeat
	set d to -1
	repeat while d < 0
		display alert ("Paths: " & pathlist as text)
		set entry to text returned of (display dialog "Choose a path:" default answer "")
		if entry = "ahead" then
			set d to f
		else if entry = "right" then
			set d to 1 + (f mod 4)
		else if entry = "back" then
			set d to 1 + ((f + 1) mod 4)
		else if entry = "left" then
			set d to 1 + ((f + 2) mod 4)
		else if entry = "exit" then
			if xp = 127 and yp = 127 then
                display alert "You have exited the maze."
				set d to 5
			else
			    display alert "You are not at the exit."
			end if
		else if entry = "quit" then
			set d to 5
        else
            display alert "Invalid entry."
		end if
	end repeat
	if d = 1 then
		if item (4 * (a - 1) + 1) of e then
			set xp to xp + 1
			set d to f
		else
			set d to -1
		end if
	else if d = 2 then
		if item (4 * (a - 1) + 2) of e then
			set yp to yp + 1
			set d to f
		else
			set d to -1
		end if
	else if d = 3 then
		if item (4 * (a - 1) + 3) of e then
			set xp to xp - 1
			set d to f
		else
			set d to -1
		end if
	else if d = 4 then
		if item (4 * (a - 1) + 4) of e then
			set yp to yp - 1
			set d to f
		else
			set d to -1
		end if
	end if
	if d < 0 then display alert "No path."
end repeat
