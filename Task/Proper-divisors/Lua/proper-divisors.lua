-- Return a table of the proper divisors of n
function propDivs (n)
    if n < 2 then return {} end
    local divs, sqr = {1}, math.sqrt(n)
    for d = 2, sqr do
        if n % d == 0 then
            table.insert(divs, d)
            if d ~= sqr then table.insert(divs, n/d) end
        end
    end
    table.sort(divs)
    return divs
end

-- Show n followed by all values in t
function show (n, t)
    io.write(n .. ":\t")
    for _, v in pairs(t) do io.write(v .. " ") end
    print()
end

-- Main procedure
local mostDivs, numDivs, answer = 0
for i = 1, 10 do show(i, propDivs(i)) end
for i = 1, 20000 do
    numDivs = #propDivs(i)
    if numDivs > mostDivs then
        mostDivs = numDivs
        answer = i
    end
end
print(answer .. " has " .. mostDivs .. " proper divisors.")
