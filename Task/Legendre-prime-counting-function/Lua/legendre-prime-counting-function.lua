do  -- Legendre prime counting function - translation of EasyLang

    -- generate and return a table containing the primes up to sieveSize
    local function primeSieve( sieveSize )
        local sieve = {}
        sieve[ 1 ] = false
        for sPos = 2, sieveSize do sieve[ sPos ] = true end
        -- sieve the primes
        for sPos = 2, math.floor( math.sqrt( sieveSize ) ) do
            if sieve[ sPos ] then
                for p = sPos * sPos, sieveSize, sPos do
                    sieve[ p ] = false
                end
            end
        end
        return sieve
    end

    -- construct a sieve of primes up to the maximum we will need
    local psRoot1e9 = primeSieve( math.sqrt( 1e9 ) )

    -- returns a table of primes extracted from a prime sieve
    local function primesUpTo( n, sieve )
        local result = {}
        for sPos = 1, n do
            if sieve[ sPos ] then table.insert( result, sPos ) end
        end
        return result
    end

    local function pi( n )
        local result = 0
        if n == 2 then result = 1
        elseif n > 2 then
            local rootN      = math.floor( math.sqrt( n ) )
            local primes     = primesUpTo( rootN, psRoot1e9 )
            local primeCount = # primes

            local function phi( x, aIn )
                local a, sum, found1 = aIn, 0, false
                while a > 1 and not found1 do
                    local pa = primes[ a ]
                    if x <= pa then
                        found1 = true
                    else
                        a   = a - 1
                        sum = sum + phi( x // pa, a )
                    end
                end
                return found1 and 1 or x - ( x // 2 ) - sum
            end

            result = phi( n, primeCount ) + primeCount - 1
        end
        return result
    end

    for i = 0, 9 do
        local n = math.floor( 10 ^ i )
        print( "10^"..i.."  "..pi( n ) )
    end
end
