set n to 5

set m to {}
repeat with i from 1 to n
	set end of m to {} -- Built a foundation for the matrix out of n empty lists.
end repeat

set {v, d, i} to {0, -1, 1}
repeat while v < n ^ 2
	if length of m's item i < n then
		set {end of m's item i, i, v} to {f(v, n), i + d, v + 1}
		if i < 1 then
			set {i, d} to {1, -d}
		else if i > n then
			set {i, d} to {n, -d}
		else if i > 1 and (count of m's item (i - 1)) = 1 then
			set d to -d
		end if
	else
		set {i, d} to {i + 1, 1}
	end if
end repeat

-- Handler/function to format the cells on the fly.
on f(v, n)
	return (characters -(length of (n ^ 2 as string)) thru -1 of ("          " & v)) as string
end f

-- Reformat the matrix into a table for viewing.
set text item delimiters to ""
repeat with i in m
	set i's contents to (i as string) & return
end repeat
return return & m as string
