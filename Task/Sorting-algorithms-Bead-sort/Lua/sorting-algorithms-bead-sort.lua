-- Display message followed by all values of a table in one line
function show (msg, t)
    io.write(msg .. ":\t")
    for _, v in pairs(t) do io.write(v .. " ") end
    print()
end

-- Return a table of random numbers
function randList (length, lo, hi)
    local t = {}
    for i = 1, length do table.insert(t, math.random(lo, hi)) end
    return t
end

-- Count instances of numbers that appear in counting to each list value
function tally (list)
    local tal = {}
    for k, v in pairs(list) do
        for i = 1, v do
            if tal[i] then tal[i] = tal[i] + 1 else tal[i] = 1 end
        end
    end
    return tal
end

-- Sort a table of positive integers into descending order
function beadSort (numList)
    show("Before sort", numList)
    local abacus = tally(numList)
    show("Tally list", abacus)
    local sorted = tally(abacus)
    show("After sort", sorted)
end

-- Main procedure
math.randomseed(os.time())
beadSort(randList(10, 1, 10))
