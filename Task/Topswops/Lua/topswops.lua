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

-- Perform one topswop round on table t
function swap (t)
    local new, limit = {}, t[1]
    for i = 1, #t do
        if i <= limit then
            new[i] = t[limit - i + 1]
        else
            new[i] = t[i]
        end
    end
    return new
end

-- Find the most swaps needed for any starting permutation of n cards
function topswops (n)
    local numTab, highest, count = {}, 0
    for i = 1, n do numTab[i] = i end
    for numList in permute(numTab) do
        count = 0
        while numList[1] ~= 1 do
            numList = swap(numList)
            count = count + 1
        end
        if count > highest then highest = count end
    end
    return highest
end

-- Main procedure
for i = 1, 10 do print(i, topswops(i)) end
