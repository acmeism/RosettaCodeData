do  -- find some Fermat pseudo primes; x is a fermat pseudoprime in
    -- base a if a^(x-1) - 1 is divisible by x and x is not prime

    local maxPrime <const> = 50000
    -- construct a sieve of primes to maxPrime
    local prime <const> = {}
    for sPos = 1, maxPrime do prime[ sPos ] = sPos % 2 == 1 end
    prime[ 1 ], prime[ 2 ] = false, true
    for sPos = 3, math.sqrt( maxPrime ), 2 do
        if prime[ sPos ] then
            for p = sPos * sPos, maxPrime, sPos do prime[ p ] = false end
        end
    end

    -- returns "a^n mod m"
    local function powMod( a, n, m )
        local a1, n1, result = a % m, n, 0
        if a1 > 0 then
            result = 1
            while n1 > 0 do
                if ( n1 & 1 ) ~= 0 then result = ( result * a1 ) % m end
                n1 = n1 >> 1
                a1 = ( a1 * a1 ) % m
            end
        end
        return result
    end

    for base = 1, 20 do
        local fp <const> = {}
        for i = 1, 20 do fp[ i ] = 0 end
        local count = 0
        -- x from 3 as 1 is neither composite nor prime and 2 is prime
        if base == 1 then
            -- 1^(x-1) is 1 for all x, so all composites are fermat pseudo primes in base 1
            for x = 3, maxPrime do
                if not prime[ x ] then
                    count = count + 1
                    if count <= # fp then fp[ count ] = x end
                end
            end
        else
            -- must test base^(x-1) % x
            for x = 3, maxPrime, ( base & 1 == 1 and 1 or 2 ) do
                if not prime[ x ] then
                    if powMod( base, x - 1, x ) == 1 then
                        -- have a composite x that divides base^(x-1)-1
                        count = count + 1
                        if count <= # fp then fp[ count ] = x end
                    end
                end
            end
        end
        io.write( string.format( "base %2d to %d total: %d\n     first:", base, maxPrime, count ) )
        for fPos = 1, # fp do io.write( string.format( " %d", fp[ fPos ] ) ) end
        io.write( "\n" )
    end

end
