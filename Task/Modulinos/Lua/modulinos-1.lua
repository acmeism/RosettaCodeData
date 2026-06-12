#!/usr/bin/env lua

function meaningoflife()
	return 42
end

function main(arg)
	print("Main: The meaning of life is " .. meaningoflife())
end

if type(package.loaded[(...)]) ~= "userdata" then
	main(arg)
else
	module(..., package.seeall)
end
