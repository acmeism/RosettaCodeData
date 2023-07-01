set array to {1, 2, 3, 4, 5, 6}
set evens to {}
repeat with i in array
	if (i mod 2 = 0) then set end of evens to i's contents
end repeat
return evens
