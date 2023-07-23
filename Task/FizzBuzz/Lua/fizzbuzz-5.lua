local mt = {
	__newindex = (function (t, k, v)
		if type(k) ~= "number" then	rawset(t, k, v)
		elseif 0 == (k % 15) then	rawset(t, k, "fizzbuzz")
		elseif 0 == (k % 5) then	rawset(t, k, "fizz")
		elseif 0 == (k % 3) then	rawset(t, k, "buzz")
		else 						rawset(t, k, k) end
		return t[k]
end)
}

local fizzbuzz = {}
setmetatable(fizzbuzz, mt)

for i=1,100 do fizzbuzz[i] = i end
for i=1,100 do print(fizzbuzz[i]) end
