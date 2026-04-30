on magic(n)
	n * (n ^ 2 + 1) / 2
end magic

repeat with i from 3 to 22
	log magic(i) as integer
end repeat

log magic(1003) as integer

on inv_magic(lower)
	set n to 3
	repeat until magic(n) > lower
		set n to n + 1
	end repeat
	return n
end inv_magic

repeat with i from 1 to 20
	log inv_magic(10 ^ i)
end repeat
