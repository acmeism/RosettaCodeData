on digitalroot(N as integer)
	script math
		to sum(L)
			if L = {} then return 0
			(item 1 of L) + sum(rest of L)
		end sum
	end script
	
	set i to 0
	set M to N
	
	repeat until M < 10
		set digits to the characters of (M as text)
		set M to math's sum(digits)
		set i to i + 1
	end repeat
	
	{N:N, persistences:i, root:M}
end digitalroot


digitalroot(627615)
