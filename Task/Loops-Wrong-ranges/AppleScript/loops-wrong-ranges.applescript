on looptest(start, finish, step)
	set a to {}
	try
		repeat with i from start to finish by step
			set a to a & i
			if length of a = 10 then exit repeat
		end repeat
		return a
	on error
		return "Not allowed"
	end try
end looptest

set test_cases to {{"Normal", -2, 2, 1}, ¬
	{"Zero step", -2, 2, 0}, ¬
	{"Step away from stop value", -2, 2, -1}, ¬
	{"Step value > stop value", -2, 2, 10}, ¬
	{"Start > stop, positive step", 2, -2, 1}, ¬
	{"Start = stop, positive step", 2, 2, 1}, ¬
	{"Start = stop, negative step", 2, 2, -1}, ¬
	{"Start = stop, zero step", 2, 2, 0}, ¬
	{"Start, stop, step all zero", 0, 0, 0}}

repeat with lst in test_cases
	log item 1 of lst
	log looptest(item 2 of lst, item 3 of lst, item 4 of lst)
end repeat
