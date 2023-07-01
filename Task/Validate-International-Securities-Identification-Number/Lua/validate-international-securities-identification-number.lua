function luhn (n)
    local revStr, s1, s2, digit, mod = n:reverse(), 0, 0
    for pos = 1, #revStr do
        digit = tonumber(revStr:sub(pos, pos))
        if pos % 2 == 1 then
            s1 = s1 + digit
        else
            digit = digit * 2
            if digit > 9 then
                mod = digit % 10
                digit = mod + ((digit - mod) / 10)
            end
            s2 = s2 + digit
        end
    end
    return (s1 + s2) % 10 == 0
end

function checkISIN (inStr)
    if #inStr ~= 12 then return false end
    local numStr = ""
    for pos = 1, #inStr do
        numStr = numStr .. tonumber(inStr:sub(pos, pos), 36)
    end
    return luhn(numStr)
end

local testCases = {
    "US0378331005",
    "US0373831005",
    "US0373831005",
    "US03378331005",
    "AU0000XVGZA3",
    "AU0000VXGZA3",
    "FR0000988040"
}
for _, ISIN in pairs(testCases) do print(ISIN, checkISIN(ISIN)) end
