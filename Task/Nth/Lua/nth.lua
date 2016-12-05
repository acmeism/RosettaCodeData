function getSuffix (n)
    local lastTwo, lastOne = n % 100, n % 10
    if lastTwo > 3 and lastTwo < 21 then return "th" end
    if lastOne == 1 then return "st" end
    if lastOne == 2 then return "nd" end
    if lastOne == 3 then return "rd" end
    return "th"
end

function Nth (n) return n .. "'" .. getSuffix(n) end

for i = 0, 25 do print(Nth(i), Nth(i + 250), Nth(i + 1000)) end
