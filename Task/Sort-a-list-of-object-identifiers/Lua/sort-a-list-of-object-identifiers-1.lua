local OIDs = {
    "1.3.6.1.4.1.11.2.17.19.3.4.0.10",
    "1.3.6.1.4.1.11.2.17.5.2.0.79",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.4",
    "1.3.6.1.4.1.11150.3.4.0.1",
    "1.3.6.1.4.1.11.2.17.19.3.4.0.1",
    "1.3.6.1.4.1.11150.3.4.0"
}

function compare (a, b)
    local aList, bList, Na, Nb = {}, {}
    for num in a:gmatch("%d+") do table.insert(aList, num) end
    for num in b:gmatch("%d+") do table.insert(bList, num) end
    for i = 1, math.max(#aList, #bList) do
        Na, Nb = tonumber(aList[i]) or 0, tonumber(bList[i]) or 0
        if Na ~= Nb then return Na < Nb end
    end
end

table.sort(OIDs, compare)
for _, oid in pairs(OIDs) do print(oid) end
