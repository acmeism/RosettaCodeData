function isMunchausen (n)
    local sum, nStr, digit = 0, tostring(n)
    for pos = 1, #nStr do
        digit = tonumber(nStr:sub(pos, pos))
        sum = sum + digit ^ digit
    end
    return sum == n
end

-- alternative, faster version based on the C version,
-- avoiding string manipulation, for Lua 5.3 or higher
local function isMunchausen (n)
    local sum, digit, acc = 0, 0, n
    while acc > 0 do
        digit = acc % 10.0
        sum = sum + digit ^ digit
        acc = acc // 10 -- integer div
    end
    return sum == n
end

for i = 1, 5000 do
    if isMunchausen(i) then print(i) end
end
