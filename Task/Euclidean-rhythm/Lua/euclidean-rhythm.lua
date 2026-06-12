function E(k, n)
    local s = {}
    for i = 1, n do
        if i <= k then
            table.insert(s, {1})
        else
            table.insert(s, {0})
        end
    end

    local d = n - k
    n = math.max(k, d)
    k = math.min(k, d)
    local z = d

    while z > 0 or k > 1 do
        for i = 1, k do
            for _, v in ipairs(s[#s - i + 1]) do
                table.insert(s[i], v)
            end
        end
        for i = 1, k do
            table.remove(s)
        end
        z = z - k
        d = n - k
        n = math.max(k, d)
        k = math.min(k, d)
    end

    local result = {}
    for _, sublist in ipairs(s) do
        for _, item in ipairs(sublist) do
            table.insert(result, item)
        end
    end
    return result
end

local result = E(5, 13)
for _, v in ipairs(result) do
    io.write(v)
end
io.write('\n')
-- Output should be 1001010010100
