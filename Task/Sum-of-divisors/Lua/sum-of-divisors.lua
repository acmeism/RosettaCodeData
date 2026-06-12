do -- sum the divisors of the first 100 positive integers

    -- computes the sum of the divisors of v using the prime factorisation
    function divisor_sum( v )
        local total, power, n = 1, 2, v
            while n % 2 == 0 do                       -- Deal with powers of 2 first
                total = total + power
                power = power * 2
                n     = math.floor( n / 2 )
            end
            local p = 3                   -- Odd prime factors up to the square root
            while ( p * p ) <= n do
                local sum = 1
                power     = p
                while n % p == 0 do
                    sum   = sum + power
                    power = power * p
                    n     = math.floor( n / p )
                end
                p     = p + 2
                total = total * sum
            end
            if n > 1 then total = total * ( n + 1 ) end  -- If n > 1 then it's prime
            return total
        end

    -- show the first 100 divisor sums
    local limit = 100
    io.write( "Sum of divisors for the first ", limit, " positive integers:\n" )
    for n = 1, limit do
        io.write( string.format( " %4d", divisor_sum( n ) ) )
        if n % 10 == 0 then io.write( "\n" ) end
    end

end
