-- Returns a boolean indicating whether n is prime
function isPrime (n)
    if n < 2 then return false end
    if n < 4 then return true end
    if n % 2 == 0 then return false end
    for d = 3, math.sqrt(n), 2 do
        if n % d == 0 then return false end
    end
    return true
end

-- Returns a table of the prime factors of n
function primeFactors (n)
    local pfacs, divisor = {}, 1
    if n < 1 then return pfacs end
    while not isPrime(n) do
        while not isPrime(divisor) do divisor = divisor + 1 end
        while n % divisor == 0 do
            n = n / divisor
            table.insert(pfacs, divisor)
        end
        divisor = divisor + 1
        if n == 1 then return pfacs end
    end
    table.insert(pfacs, n)
    return pfacs
end

-- Returns the sum of the digits of n
function sumDigits (n)
    local sum, nStr = 0, tostring(n)
    for digit = 1, nStr:len() do
        sum = sum + tonumber(nStr:sub(digit, digit))
    end
    return sum
end

-- Returns a boolean indicating whether n is a Smith number
function isSmith (n)
    if isPrime(n) then return false end
    local sumFacs = 0
    for _, v in ipairs(primeFactors(n)) do
        sumFacs = sumFacs + sumDigits(v)
    end
    return sumFacs == sumDigits(n)
end

-- Main procedure
for n = 1, 10000 do
    if isSmith(n) then io.write(n .. "\t") end
end
