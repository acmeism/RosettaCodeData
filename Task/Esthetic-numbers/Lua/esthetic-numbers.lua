function to(n, b)
    local BASE = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"

    if n == 0 then
        return "0"
    end

    local ss = ""
    while n > 0 do
        local idx = (n % b) + 1
        n = math.floor(n / b)
        ss = ss .. BASE:sub(idx, idx)
    end
    return string.reverse(ss)
end

function isEsthetic(n, b)
    function uabs(a, b)
        if a < b then
            return b - a
        end
        return a - b
    end

    if n == 0 then
        return false
    end
    local i = n % b
    n = math.floor(n / b)
    while n > 0 do
        local j = n % b
        if uabs(i, j) ~= 1 then
            return false
        end
        n = math.floor(n / b)
        i = j
    end
    return true
end

function listEsths(n, n2, m, m2, perLine, all)
    local esths = {}
    function dfs(n, m, i)
        if i >= n and i <= m then
            table.insert(esths, i)
        end
        if i == 0 or i > m then
            return
        end
        local d = i % 10
        local i1 = 10 * i + d - 1
        local i2 = i1 + 2
        if d == 0 then
            dfs(n, m, i2)
        elseif d == 9 then
            dfs(n, m, i1)
        else
            dfs(n, m, i1)
            dfs(n, m, i2)
        end
    end

    for i=0,9 do
        dfs(n2, m2, i)
    end
    local le = #esths
    print(string.format("Base 10: %s esthetic numbers between %s and %s:", le, math.floor(n), math.floor(m)))
    if all then
        for c,esth in pairs(esths) do
            io.write(esth.." ")
            if c % perLine == 0 then
                print()
            end
        end
        print()
    else
        for i=1,perLine do
            io.write(esths[i] .. " ")
        end
        print("\n............")
        for i = le - perLine + 1, le do
            io.write(esths[i] .. " ")
        end
        print()
    end
    print()
end

for b=2,16 do
    print(string.format("Base %d: %dth to %dth esthetic numbers:", b, 4 * b, 6 * b))
    local n = 1
    local c = 0
    while c < 6 * b do
        if isEsthetic(n, b) then
            c = c + 1
            if c >= 4 * b then
                io.write(to(n, b).." ")
            end
        end
        n = n + 1
    end
    print()
end
print()

-- the following all use the obvious range limitations for the numbers in question
listEsths(1000, 1010, 9999, 9898, 16, true)
listEsths(1e8, 101010101, 13 * 1e7, 123456789, 9, true)
listEsths(1e11, 101010101010, 13 * 1e10, 123456789898, 7, false)
listEsths(1e14, 101010101010101, 13 * 1e13, 123456789898989, 5, false)
listEsths(1e17, 101010101010101010, 13 * 1e16, 123456789898989898, 4, false)
