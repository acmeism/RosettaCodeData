set s to ""
repeat with n from 1 to 10
	set s to s & n
	if n = 10 then exit repeat
	set s to s & ", "
end repeat
s
