function isPrime (x)
    if x < 2 then return false end
    if x < 4 then return true end
    if x % 2 == 0 then return false end
    for d = 3, math.sqrt(x), 2 do
        if x % d == 0 then return false end
    end
    return true
end

function primes ()
    local x, maxInt = 3, 2^53
    local function yieldPrimes ()
        coroutine.yield(2)
        repeat
            if isPrime(x) then coroutine.yield(x) end
            x = x + 2
        until x == maxInt
    end
    return coroutine.wrap(function() yieldPrimes() end)
end

function factorial (n)
    local f = 1
    for i = 2, n do
        f = f * i
    end
    return f
end

function isErdos (p)
    local k, factK = 1
    repeat
        factK = factorial(k)
        if isPrime(p - factK) then return false end
        k = k + 1
    until factK >= p
    return true
end

local nextPrime, count, prime = primes(), 0
while count < 7875 do
    prime = nextPrime()
    if isErdos(prime) then
        if prime < 2500 then io.write(prime .. " ") end
        count = count + 1
    end
end
print("\n\nThe 7875th Erdos prime is " .. prime)
