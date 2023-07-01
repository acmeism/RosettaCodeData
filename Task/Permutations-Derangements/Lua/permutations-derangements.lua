-- Return an iterator to produce every permutation of list
function permute (list)
    local function perm (list, n)
        if n == 0 then coroutine.yield(list) end
        for i = 1, n do
            list[i], list[n] = list[n], list[i]
            perm(list, n - 1)
            list[i], list[n] = list[n], list[i]
        end
    end
    return coroutine.wrap(function() perm(list, #list) end)
end

-- Return a copy of table t (wouldn't work for a table of tables)
function copy (t)
    if not t then return nil end
    local new = {}
    for k, v in pairs(t) do new[k] = v end
    return new
end

-- Return true if no value in t1 can be found at the same index of t2
function noMatches (t1, t2)
    for k, v in pairs(t1) do
        if t2[k] == v then return false end
    end
    return true
end

-- Return a table of all derangements of table t
function derangements (t)
    local orig = copy(t)
    local nextPerm, deranged = permute(t), {}
    local numList, keep = copy(nextPerm())
    while numList do
        if noMatches(numList, orig) then table.insert(deranged, numList) end
        numList = copy(nextPerm())
    end
    return deranged
end

-- Return the subfactorial of n
function subFact (n)
    if n < 2 then
        return 1 - n
    else
        return (subFact(n - 1) + subFact(n - 2)) * (n - 1)
    end
end

-- Return a table of the numbers 1 to n
function listOneTo (n)
    local t = {}
    for i = 1, n do t[i] = i end
    return t
end

-- Main procedure
print("Derangements of [1,2,3,4]")
for k, v in pairs(derangements(listOneTo(4))) do print("", unpack(v)) end
print("\n\nSubfactorial vs counted derangements\n")
print("\tn\t| subFact(n)\t| Derangements")
print("    " .. string.rep("-", 42))
for i = 0, 9 do
    io.write("\t" .. i .. "\t|  " .. subFact(i))
    if string.len(subFact(i)) < 5 then io.write("\t") end
    print("\t|  " .. #derangements(listOneTo(i)))
end
print("\n\nThe subfactorial of 20 is " .. subFact(20))
