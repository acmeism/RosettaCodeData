function sattolo (items)
    local j
    for i = #items, 2, -1 do
        j = math.random(i - 1)
        items[i], items[j] = items[j], items[i]
    end
end

math.randomseed(os.time())
local testCases = {
    {},
    {10},
    {10, 20},
    {10, 20, 30},
    {11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22}
}
for _, array in pairs(testCases) do
    sattolo(array)
    print("[" .. table.concat(array, ", ") .. "]")
end
