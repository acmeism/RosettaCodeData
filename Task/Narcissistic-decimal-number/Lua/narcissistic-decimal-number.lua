function isNarc (n)
    local m, sum, digit = string.len(n), 0
    for pos = 1, m do
        digit = tonumber(string.sub(n, pos, pos))
        sum = sum + digit^m
    end
    return sum == n
end

local n, count = 0, 0
repeat
    if isNarc(n) then
        io.write(n .. " ")
        count = count + 1
    end
    n = n + 1
until count == 25
