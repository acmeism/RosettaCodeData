assert(math.type~=nil, "Lua 5.3+ required for this test.")
minint, maxint = math.mininteger, math.maxinteger
print("min, max int64  = " .. minint .. ", " .. maxint)
print("min-1 underflow =  " .. (minint-1) .. "  equals max? " .. tostring(minint-1==maxint))
print("max+1 overflow  = " .. (maxint+1) .. "  equals min? " .. tostring(maxint+1==minint))
