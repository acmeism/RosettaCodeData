function isDisarium (x)
    local str, sum, digit = tostring(x), 0
    for pos = 1, #str do
        digit = tonumber(str:sub(pos, pos))
        sum = sum + (digit ^ pos)
    end
    return sum == x
end

local count, n = 0, 0
while count < 19 do
    if isDisarium(n) then
        count = count + 1
        io.write(n .. " ")
    end
    n = n + 1
end
