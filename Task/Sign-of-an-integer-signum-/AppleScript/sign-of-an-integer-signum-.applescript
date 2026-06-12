on signum(x)
	if x > 0 then
		return 1
	else if x < 0 then
		return -1
	else
		return x
	end if
end signum

repeat with x in {-10, 42, 0}
	log signum(x)
end repeat
