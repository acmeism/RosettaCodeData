do --[[ find some "Calmo" numbers: numbers n such that they have 3k divisors
        (other than 1 and n) for some k > 0 and the sum of their divisors
        taken three at a time is a prime
   --]]

    local maxNumber = 1000                  -- largest number we will consider
    -- construct a sieve of (hopefully) enough primes - as we are going to sum
    -- the divisors in groups of three, it should be (more than) large enough
    local isPrime, maxPrime = {}, maxNumber * 2
    for sPos = 1, maxPrime do isPrime[ sPos ] = sPos % 2 == 1 end
    isPrime[ 1 ] = false
    isPrime[ 2 ] = true
    for sPos = 3, math.sqrt( maxPrime ), 2 do
        if isPrime[ sPos ] then
            for p = sPos * sPos, maxPrime, sPos do isPrime[ p ] = false end
        end
    end

    -- construct tables of the divisor counts and divisor sums and check for
    -- the numbers as we do it
    -- as we are ignoring 1 and n, the initial counts and sums will be 0
    -- but we should ignore primes
    local dsum, dcount = {}, {}
    for i = 1, maxNumber do
        dcount[ i ] = ( isPrime[ i ] and -1 or 0 )
        dsum[   i ] = dcount[ i ]
    end
    for i = 2, maxNumber do
        for j = i + i, maxNumber, i do
            -- have another proper divisor
            if dsum[ j ] >= 0 then
                -- this number is still a candidate
                dsum[   j ] = dsum[   j ] + i
                dcount[ j ] = dcount[ j ] + 1
                if dcount[ j ] == 3 then
                    -- the divisor count is currently 3
                    -- if the divisor sum isn't prime, ignore it in future
                    -- if the divisor sum is prime, reset the sum and count
                    dcount[ j ] = ( not isPrime[ dsum[ j ] ] and -1 or 0 )
                    dsum[   j ] = dcount[ j ]
                end
            end
        end
    end
    -- show the numbers, they will have 0 in the divisor count
    for i = 2, maxNumber do
        if dcount[ i ] == 0 then
            io.write( " ", i )
        end
    end
    io.write( "\n" )
end
