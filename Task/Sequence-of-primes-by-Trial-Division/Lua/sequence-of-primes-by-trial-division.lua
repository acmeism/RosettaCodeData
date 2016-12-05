-- Returns true if x is prime, and false otherwise
function isprime (x)
    if x < 2 then return false end
    if x < 4 then return true end
    if x % 2 == 0 then return false end
    for d = 3, math.sqrt(x), 2 do
        if x % d == 0 then return false end
    end
    return true
end

-- Returns table of prime numbers (from lo, if specified) up to hi
function primes (lo, hi)
    local t = {}
    if not hi then
        hi = lo
        lo = 2
    end
    for n = lo, hi do
        if isprime(n) then table.insert(t, n) end
    end
    return t
end

-- Show all the values of a table in one line
function show (x)
    for _, v in pairs(x) do io.write(v .. " ") end
    print()
end

-- Main procedure
show(primes(100))
show(primes(50, 150))
