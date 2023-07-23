#!/usr/bin/env luajit
local to=arg[1] or tonumber(arg[1]) or 100
local CF,CB=3,5
local cf,cb=CF,CB
for i=1,to do
	cf,cb=cf-1,cb-1
	if cf~=0 and cb~=0 then
		io.write(i)
	else
		if cf==0 then
			cf=CF
			io.write("Fizz")
		end
		if cb==0 then
			cb=CB
			io.write("Buzz")
		end
	end
	io.write(", ")
end
