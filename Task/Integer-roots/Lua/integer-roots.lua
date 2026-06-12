function root(base, n)
    if base < 2 then return base end
    if n == 0 then return 1 end

    local n1 = n - 1
    local n2 = n
    local n3 = n1
    local c = 1
    local d = math.floor((n3 + base) / n2)
    local e = math.floor((n3 * d + base / math.pow(d, n1)) / n2)

    while c ~= d and c ~= e do
        c = d
        d = e
        e = math.floor((n3 * e + base / math.pow(e, n1)) / n2)
    end

    if d < e then return d end
    return e
end

-- main
local b = 2e18

print("3rd root of 8 = " .. root(8, 3))
print("3rd root of 9 = " .. root(9, 3))
print("2nd root of " .. b .. " = " .. root(b, 2))
