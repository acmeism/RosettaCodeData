do  -- find some Wagstaff primes primes of the form ( 2^p + 1 ) / 3
    --                            where p is an odd prime

    local maxWagstaff <const> =  10      -- number of Wagstaff primes to find
    local sieveSize   <const> = 200      -- hopefully, enough primes...
    local primes              = {}
    do                                    -- sieve the primes up to sieveMax
        primes[ 1 ] = false
        for sPos = 2, sieveSize do primes[ sPos ] = true end
        for sPos = 2, math.floor( math.sqrt( sieveSize ) ) do
            if primes[ sPos ] then
                for p = sPos * sPos, sieveSize, sPos do
                    primes[ p ] = false
                end
            end
        end
    end
    do                         -- attempt to find the Wagstaff primes
        local powerOf2 = 2     -- 2^1
        local wCount   = 0     -- number of Wagstaff primes found so far
        for p = 3, sieveSize, 2 do
            if wCount >= maxWagstaff then break end
            powerOf2 = powerOf2 * 4
            if primes[ p ] then
                local w, isPrime = ( powerOf2 + 1 ) // 3, true
                -- check w is prime - trial division
                for n = 3, w, 2 do
                    if n * n > w or not isPrime then break end
                    isPrime = w % n ~= 0
                end
                if isPrime then -- have another Wagstaff prime
                    wCount = wCount + 1
                    io.write( string.format( "%2d %4d: %16d\n", wCount, p, w ) )
                end
            end
        end
    end
end
