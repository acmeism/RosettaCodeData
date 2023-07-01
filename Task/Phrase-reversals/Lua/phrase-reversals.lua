-- Return a copy of table t in which each string is reversed
function reverseEach (t)
    local rev = {}
    for k, v in pairs(t) do rev[k] = v:reverse() end
    return rev
end

-- Return a reversed copy of table t
function tabReverse (t)
    local revTab = {}
    for i, v in ipairs(t) do revTab[#t - i + 1] = v end
    return revTab
end

-- Split string str into a table on space characters
function wordSplit (str)
    local t = {}
    for word in str:gmatch("%S+") do table.insert(t, word) end
    return t
end

-- Main procedure
local str = "rosetta code phrase reversal"
local tab = wordSplit(str)
print("1. " .. str:reverse())
print("2. " .. table.concat(reverseEach(tab), " "))
print("3. " .. table.concat(tabReverse(tab), " "))
