function arraycompare(a, b)
    for i = 1, #a do
        if b[i] == nil then
            return true
        end
        if a[i] ~= b[i] then
            return a[i] < b[1]
        end
    end
    return true
end
