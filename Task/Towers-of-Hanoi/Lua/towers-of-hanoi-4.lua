#!/usr/bin/env luajit
-- binary solution
local bit=require"bit"
local band,bor=bit.band,bit.bor
local function hanoi(n)
	local even=(n-1)%2
	for m=1,2^n-1 do
		io.write(m,":",band(m,m-1)%3+1, "→", (bor(m,m-1)+1)%3+1, " ")
	end
end

local num=arg[1] and tonumber(arg[1]) or 4

hanoi(num)
