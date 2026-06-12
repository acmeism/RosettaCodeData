local function isPrime(n)
    if n <= 3 then return n > 1
    elseif n % 2 == 0 or n % 3 == 0 then return false
    else
        for i = 5, math.floor( math.sqrt( n ) ), 6 do
            if n % i == 0 or n % (i + 2) == 0 then return false end
        end
        return true
    end
end

local primes, sum = {}, 0
for n = 2, 1000 do
    if isPrime(n) then
        sum = sum + n
        if isPrime(sum) then table.insert( primes, n ) end
    end
end
print( # primes .. " found: " .. table.concat( primes, " " ) )
