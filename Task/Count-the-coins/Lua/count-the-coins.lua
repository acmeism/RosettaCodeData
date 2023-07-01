function countSums (amount, values)
    local t = {}
    for i = 1, amount do t[i] = 0 end
    t[0] = 1
    for k, val in pairs(values) do
        for i = val, amount do t[i] = t[i] + t[i - val] end
    end
    return t[amount]
end

print(countSums(100, {1, 5, 10, 25}))
print(countSums(100000, {1, 5, 10, 25, 50, 100}))
