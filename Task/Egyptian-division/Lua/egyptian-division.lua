function egyptian_divmod(dividend,divisor)
    local pwrs, dbls = {1}, {divisor}
    while dbls[#dbls] <= dividend do
        table.insert(pwrs, pwrs[#pwrs] * 2)
        table.insert(dbls, pwrs[#pwrs] * divisor)
    end
    local ans, accum = 0, 0

    for i=#pwrs-1,1,-1 do
        if accum + dbls[i] <= dividend then
            accum = accum + dbls[i]
            ans = ans + pwrs[i]
        end
    end

    return ans, math.abs(accum - dividend)
end

local i, j = 580, 34
local d, m = egyptian_divmod(i, j)
print(i.." divided by "..j.." using the Egyptian method is "..d.." remainder "..m)
