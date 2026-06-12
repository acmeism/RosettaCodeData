do  -- find extra primes - numbers whose digits are prime and whose
    -- digit sum is prime; other than the 1 digit primes, the first three
    -- digits can be 0, 2, 3, 5, 7 and the final digit can only be 3 or 7

    local function isPrime( n )
        if     n < 4      then return n > 1
        elseif n % 3 == 0 then return false
        elseif n % 2 == 0 then return false
        else
            local isAPrime, f = true, 5
            while isAPrime and f * f <= n do
                isAPrime, f = n % f ~= 0, f + 2
            end
            return isAPrime
        end
    end

    -- first four numbers ) i.e. the 1 digit primes ) as a special case
    io.write( "    2    3    5    7" )
    local count = 4
    for i1 = -1, 7, 2 do
        local d1 = i1 < 3 and i1 + 1 or i1
        for i2 = -1, 7, 2 do
            local d2 = i2 < 3 and i2 + 1 or i2
            if ( d1 + d2 ) == 0 or d2 ~= 0 then
                for i3 = 1, 7, 2 do
                    local d3 = i3 < 3 and i3 + 1 or i3
                    for d4 = 3, 7, 4 do
                        local sum = d1 + d2 + d3 + d4
                        local n   = ( ( ( ( ( d1 * 10 ) + d2 ) * 10 ) + d3 ) * 10 ) + d4
                        if isPrime( sum ) and isPrime( n ) then
                            -- found a prime whose prime digits sum to a prime
                            io.write( string.format( " %4d", n ) )
                            count = count + 1
                            if count % 12 == 0 then io.write( "\n" ) end
                        end
                    end
                end
            end
        end
    end

end
