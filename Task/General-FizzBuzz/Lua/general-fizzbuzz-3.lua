#!/usr/bin/env luajit

local num = arg[1] or tonumber(arg[1]) or 110
local t = {
	{3, "Fizz"},
	{5, "Buzz"},
	{7, "Gazz"},
}

-- `cnt` contains counters for each factor-word pair; when a counter of a pair reaches its factor,
-- the counter is reset to zero and the word is written to output
local cnt = setmetatable({}, {__index = function() return 0 end})

for i = 1,num do
	for i = 1,#t do
		cnt[i] = cnt[i]+1
	end
	local match = false
	for i=1,#t do
		if cnt[i] == t[i][1] then
			io.write(t[i][2])
			cnt[i] = 0
			match = true	
		end
	end
	if not match then
		io.write(i)
	end
	io.write(", ")
end
