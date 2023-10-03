do  -- find deceptive numbers - repunits R(n) evenly divisible by composite numbers and n+1
    -- see tha task talk page based on the second Wren sample

    -- returns true if n is prime, false otherwise, uses trial division          %
    local function isPrime ( n )
        if     n < 3      then return n == 2
        elseif n % 3 == 0 then return n == 3
        elseif n % 2 == 0 then return false
        else
            local prime = true
            local f, f2, toNext = 5, 25, 24
            while f2 <= n and prime do
                prime  = n % f ~= 0
                f      = f + 2
                f2     = toNext
                toNext = toNext + 8
            end
            return prime
        end
    end

    do  -- task
        local n, count = 47, 0
        while count < 25 do
            n = n + 2
            if n % 3 ~= 0 and n % 5 ~= 0 and not isPrime( n ) then
                local mp = 10
                for p = 2, n - 1 do mp = ( mp * 10 ) % n end
                if mp == 1 then
                    count = count + 1
                    io.write( string.format( " %5d", n ) )
                    if count % 10 == 0 then io.write( "\n" ) end
                end
            end
        end
    end

end
