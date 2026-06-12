local moses = require("moses")

local function comb(n, k)
    if k < 0 or k > n then
        return 0
    end
    k = math.min(k, n-k)
    local res = 1
    for i = 1, k do
        res = res * (n - k + i) / i
    end
    return res
end

local function bernoullisTriangle(n, k)
    return moses.sum(moses.map(moses.range(k+1), function (v)
        return comb(n, v-1)
    end))
end

for i = 1, 14 do
    print("["..table.concat(moses.map(moses.range(i), function (v)
        return math.floor(bernoullisTriangle(i, v-1))
    end), ", ").."]")
end
