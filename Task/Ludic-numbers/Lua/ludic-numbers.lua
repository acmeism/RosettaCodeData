-- Return table of ludic numbers below limit
function ludics (limit)
    local ludList, numList, index = {1}, {}
    for n = 2, limit do table.insert(numList, n) end
    while #numList > 0 do
        index = numList[1]
        table.insert(ludList, index)
        for key = #numList, 1, -1 do
            if key % index == 1 then table.remove(numList, key) end
        end
    end
    return ludList
end

-- Return true if n is found in t or false otherwise
function foundIn (t, n)
    for k, v in pairs(t) do
        if v == n then return true end
    end
    return false
end

-- Display msg followed by all values in t
function show (msg, t)
    io.write(msg)
    for _, v in pairs(t) do io.write(" " .. v) end
    print("\n")
end

-- Main procedure
local first25, under1k, inRange, tripList, triplets = {}, 0, {}, {}, {}
for k, v in pairs(ludics(30000)) do
    if k <= 25 then table.insert(first25, v) end
    if v <= 1000 then under1k = under1k + 1 end
    if k >= 2000 and k <= 2005 then table.insert(inRange, v) end
    if v < 250 then table.insert(tripList, v) end
end
for _, x in pairs(tripList) do
    if foundIn(tripList, x + 2) and foundIn(tripList, x + 6) then
        table.insert(triplets, "\n{" .. x .. "," .. x+2 .. "," .. x+6 .. "}")
    end
end
show("First 25:", first25)
print(under1k .. " are less than or equal to 1000\n")
show("2000th to 2005th:", inRange)
show("Triplets:", triplets)
