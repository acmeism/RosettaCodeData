-- Test primality by trial division
function isPrime (x)
    if x < 2 then return false end
    if x < 4 then return true end
    if x % 2 == 0 then return false end
    for d = 3, math.sqrt(x), 2 do
        if x % d == 0 then return false end
    end
    return true
end

-- Take decimal number, return binary string
function dec2bin (n)
    local bin, bit = ""
    while n > 0 do
        bit = n % 2
        n = math.floor(n / 2)
        bin = bit .. bin
    end
    return bin
end

-- Take decimal number, return population count as number
function popCount (n)
    local bin, count = dec2bin(n), 0
    for pos = 1, bin:len() do
        if bin:sub(pos, pos) == "1" then count = count + 1 end
    end
    return count
end

-- Print pernicious numbers in range if two arguments provided, or
function pernicious (x, y) -- the first 'x' if only one argument.
    if y then
        for n = x, y do
            if isPrime(popCount(n)) then io.write(n .. " ") end
        end
    else
        local n, count = 0, 0
        while count < x do
            if isPrime(popCount(n)) then
                io.write(n .. " ")
                count = count + 1
            end
            n = n + 1
        end
    end
    print()
end

-- Main procedure
pernicious(25)
pernicious(888888877, 888888888)
