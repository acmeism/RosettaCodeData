#!/usr/bin/env luajit
local lib=require"hailstone"
local longest,longest_i=0,0
for i=1,1e5 do
	local len=#lib.hailstone(i)
	if len>longest then
		longest_i=i
		longest=len
	end
end
print("Longest sequence at "..longest_i..", length "..longest)
