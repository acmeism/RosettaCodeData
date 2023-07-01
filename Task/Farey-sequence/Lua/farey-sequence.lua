-- Return farey sequence of order n
function farey (n)
    local a, b, c, d, k = 0, 1, 1, n
    local farTab = {{a, b}}
    while c <= n do
        k = math.floor((n + b) / d)
        a, b, c, d = c, d, k * c - a, k * d - b
        table.insert(farTab, {a, b})
    end
    return farTab
end

-- Main procedure
for i = 1, 11 do
    io.write(i .. ": ")
    for _, frac in pairs(farey(i)) do io.write(frac[1] .. "/" .. frac[2] .. " ") end
    print()
end
for i = 100, 1000, 100 do print(i .. ": " .. #farey(i) .. " items") end
