repeat
	set a to random number from 0 to 19
	if a is 10 then
		log a
		exit repeat
	end if
	set b to random number from 0 to 19
	log a & b
end repeat
