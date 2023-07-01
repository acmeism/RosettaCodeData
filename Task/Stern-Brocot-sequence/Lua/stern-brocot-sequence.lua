-- Task 1
function sternBrocot (n)
    local sbList, pos, c = {1, 1}, 2
    repeat
        c = sbList[pos]
        table.insert(sbList, c + sbList[pos - 1])
        table.insert(sbList, c)
        pos = pos + 1
    until #sbList >= n
    return sbList
end

-- Return index in table 't' of first value matching 'v'
function findFirst (t, v)
    for key, value in pairs(t) do
        if v then
            if value == v then return key end
        else
            if value ~= 0 then return key end
        end
    end
    return nil
end

-- Return greatest common divisor of 'x' and 'y'
function gcd (x, y)
    if y == 0 then
        return math.abs(x)
    else
        return gcd(y, x % y)
    end
end

-- Check GCD of adjacent values in 't' up to 1000 is always 1
function task5 (t)
    for pos = 1, 1000 do
        if gcd(t[pos], t[pos + 1]) ~= 1 then return "FAIL" end
    end
    return "PASS"
end

-- Main procedure
local sb = sternBrocot(10000)
io.write("Task 2: ")
for n = 1, 15 do io.write(sb[n] .. " ") end
print("\n\nTask 3:")
for i = 1, 10 do print("\t" .. i, findFirst(sb, i)) end
print("\nTask 4: " .. findFirst(sb, 100))
print("\nTask 5: " .. task5(sb))
