-- Return the distinct Fibonacci numbers not greater than 'n'
function fibsUpTo (n)
    local fibList, last, current, nxt = {}, 1, 1
    while current <= n do
        table.insert(fibList, current)
        nxt = last + current
        last = current
        current = nxt
    end
    return fibList
end

-- Return the Zeckendorf representation of 'n'
function zeckendorf (n)
    local fib, zeck = fibsUpTo(n), ""
    for pos = #fib, 1, -1 do
        if n >= fib[pos] then
            zeck = zeck .. "1"
            n = n - fib[pos]
        else
            zeck = zeck .. "0"
        end
    end
    if zeck == "" then return "0" end
    return zeck
end

-- Main procedure
print(" n\t| Zeckendorf(n)")
print(string.rep("-", 23))
for n = 0, 20 do
    print(" " .. n, "| " .. zeckendorf(n))
end
