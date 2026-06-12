local moses = require("moses")

local function binomial(n, k)
    if k < 0 or k > n then
        return 0
    end

    k = (k > n - k) and (n - k) or k
    if k == 0 then
        return 1
    end

    local num = 1
    local den = 1

    for i = 1, k do
        num = num * (n - (k - i))
        den = den * i
    end

    return num / den
end

local function moser(n)
    return 1 + binomial(n, 2) + binomial(n, 4)
end

local function binomialTransform(seq, N)
    local res = {}
    local m = #seq

    for n = 1, N do
        local s = 0
        local kmax = (n < m) and n or m
        for k = 1, kmax do
            local a_k = seq[k] or 0
            s = s + binomial(n-1, k-1) * (a_k)
        end
        res[n] = s
    end

    return res
end

local function pascalsTrianglePartialSums(N)
    local tri = {}
    local prev = {1}

    for r = 1, N do
        local sum = 0
        for c = 1, 5 do
            sum = sum + (prev[c] or 0)
        end
        tri[r] = sum

        if r < N then
            local nextRow = {}
            nextRow[1] = 1
            for c = 2, r + 1 do
                nextRow[c] = (prev[c-1] or 0) + (prev[c] or 0)
            end
            prev = nextRow
        end
    end

    return tri
end

local N = 20

print(
    "The first 20 values of Moser's circle problem calculated in different ways:\n"..
    "Direct calculation of a 4th order equation:\n"..
    "["..table.concat((function ()
        local t = {}
        for i = 1, N do
            t[#t+1] = math.floor(moser(i))
        end
        return t
    end)(), ", ").."]\n\n"..
    "Using binomial sums:\n"..
    "["..table.concat((function ()
        local t = {}
        for i = 1, N do
            t[#t+1] = math.floor(1+binomial(i, 2)+binomial(i, 4))
        end
        return t
    end)(), ", ").."]\n\n"..
    "Using a binomial transform:\n"..
    "["..table.concat(
        moses.map(
            binomialTransform(moses.append(moses.ones(5), moses.zeros(N-5)), N),
            function (v, k)
                return math.floor(v)
            end
        ),
        ", "
    ).."]\n\n"..
    "Partial sums of Pascal's triangle:\n"..
    "["..table.concat(pascalsTrianglePartialSums(N), ", ").."]\n\n"
)
