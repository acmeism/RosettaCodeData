set n to 5 -- Size of zig-zag matrix (n^2 cells).

-- Create an empty matrix.
set m to {}
repeat with i from 1 to n
	set R to {}
	repeat with j from 1 to n
		set end of R to 0
	end repeat
	set end of m to R
end repeat

-- Populate the matrix in a zig-zag manner.
set {x, y, v, d} to {1, 1, 0, 1}
repeat while v < (n ^ 2)
	if 1 ≤ x and x ≤ n and 1 ≤ y and y ≤ n then
		set {m's item y's item x, x, y, v} to {v, x + d, y - d, v + 1}
	else if x > n then
		set {x, y, d} to {n, y + 2, -d}
	else if y > n then
		set {x, y, d} to {x + 2, n, -d}
	else if x < 1 then
		set {x, y, d} to {1, y, -d}
	else if y < 1 then
		set {x, y, d} to {x, 1, -d}
	end if
end repeat
--> R = {{0, 1, 5, 6, 14}, {2, 4, 7, 13, 15}, {3, 8, 12, 16, 21}, {9, 11, 17, 20, 22}, {10, 18, 19, 23, 24}}

-- Reformat the matrix into a table for viewing.
repeat with i in m
	repeat with j in i
		set j's contents to  (characters -(length of (n ^ 2 as string)) thru -1 of ("          " & j)) as string
	end repeat
	set end of i to return
end repeat
return return & m as string
