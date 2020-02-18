#!/usr/bin/env luajit
-- Iterative version
local function ipermgen(a,b)
    if a==0 then return end
    local taken = {} local slots = {}
    for i=1,a do slots[i]=0 end
    for i=1,b do taken[i]=false end
    local index = 1
    while index > 0 do repeat
        repeat slots[index] = slots[index] + 1
        until slots[index] > b or not taken[slots[index]]
        if slots[index] > b then
            slots[index] = 0
            index = index - 1
            if index > 0 then
                taken[slots[index]] = false
            end
            break
        else
            taken[slots[index]] = true
        end
        if index == a then
			coroutine.yield(slots)
            taken[slots[index]] = false
            break
        end
        index = index + 1
    until true end
end
local function iperm(a)
	local co=coroutine.create(function() ipermgen(a,a) end)
	return function()
		local code,res=coroutine.resume(co)
			return res
		end
end

local a=arg[1] and tonumber(arg[1]) or 3
for p in iperm(a) do
	print(table.concat(p, " "))
end
