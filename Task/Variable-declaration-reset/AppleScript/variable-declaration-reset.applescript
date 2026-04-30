set s to {1, 2, 2, 3, 4, 4, 5}

repeat with i from 1 to 7
	set curr to item i of s
	if i > 1 and curr = prev then log i
	set prev to curr
end repeat
