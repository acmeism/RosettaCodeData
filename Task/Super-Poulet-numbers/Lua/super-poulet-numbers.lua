do  -- find some Super-Poulet numbers

    local maxPrime <const> = 102000000
    local isPrime  <const> = {}     -- sieve primes up to maxPrime
    do
        local rootMaxPrime <const> = math.floor( math.sqrt( maxPrime ) )
        isPrime[ 1 ], isPrime[ 2 ], isOdd = false, true, true
        for i = 3, maxPrime do
            isPrime[ i ] = isOdd
            isOdd        = not isOdd
        end
        for i = 3, rootMaxPrime, 2 do
            if isPrime[ i ] then
                for s = i * i, maxPrime, i + i do isPrime[ s ] = false end
            end
        end
    end

    local function powmod( aIn, bIn, m ) -- returns aIn ^ bIn % m
        local r, a, b = 1, aIn, bIn
        while b >= 1 do
            if b % 2 == 1 then r = ( r * a ) % m end
            b = math.floor( b / 2 )
            a = ( a * a ) % m
        end
        return r
    end

    local powmod2dd <const> = {}         -- cached powmod(2,d,d) values
    do
        for d = 0, maxPrime do powmod2dd[ d ] = -1 end
    end

    local function cachedPowmod2dd( d ) -- returns powmod( 2, d, d ) using/storing the cache
        if powmod2dd[ d ] < 0 then powmod2dd[ d ] = powmod( 2, d, d ) end
        return powmod2dd[ d ]
    end

    local function isSuperPoulet( n ) -- returns true if n is a Super Poulet number, false otherwise
        if     isPrime[ n ] then return false
        elseif n % 2 == 0   then return false
        else
            local result, d = powmod( 2, n - 1, n ) == 1, 3
            while result and d * d <= n do
                if n % d == 0 then
                    result = cachedPowmod2dd( d ) == 2
                    if result then
                        local q <const> = math.floor( n / d )
                        if q ~= d then
                            result = cachedPowmod2dd( q ) == 2
                        end
                    end
                end
                d = d + 2
            end
            return result
        end
    end

    do
        local count, searching, pn, pn1m, pn10m, pn100m = 0, true, 1, 0, 0, 0
        while searching do
            pn = pn + 2
            if isSuperPoulet( pn ) then
                count = count + 1
                if     count <= 20 then
                    io.write( string.format( " %5d", pn ) )
                    if count % 10 == 0 then io.write( "\n" ) end
                elseif pn1m == 0 and pn > 1000000 and pn1m == 0 then
                    pn1m = pn
                    io.write( "\nSuper-Poulet number "..count )
                    io.write( " ("..pn1m..") is the first over 1 000 000\n" )
                elseif pn10m == 0 and pn > 10000000 then
                    pn10m = pn
                    io.write( "Super-Poulet number "..count )
                    io.write( " ("..pn..") is the first over 10 000 000\n" )
                elseif pn100m == 0 and pn > 100000000 then
                    pn100m = pn
                    io.write( "Super-Poulet number "..count )
                    io.write( " ("..pn..") is the first over 100 000 000\n" )
                    searching = false
                end
            end
        end
    end
end
