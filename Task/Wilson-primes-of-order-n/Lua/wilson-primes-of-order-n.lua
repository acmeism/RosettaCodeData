do  -- find some Wilson primes of order n, primes p such that
    --                    ( ( n - 1 )! x ( p - n )! - (-1)^n ) mod p^2 = 0

    local maxPrime <const> = 11000

    -- returns true if p is an nth order Wilson prime, false otherwise
    local function isWilson( n, p )
        local result = false
        if p >= n then
            local p2, prod = p * p, 1
            for i = 1, n - 1 do -- prod = ( n - 1 )! % p2
                prod = ( prod * i ) % p2
            end
            for i = 1, p - n do -- prod = ( ( p - n )! * ( n - 1 )! ) % p2
                prod = ( prod * i ) % p2
            end
            result = 0 == ( p2 + prod + ( n & 1 == 1 and 1 or -1 ) ) % p2
       end
       return result
    end

    local function isprime( p )
        if p <= 2 or p % 2 == 0 then
            return p == 2
        else
            local prime, i = true, 3
            local rootP = math.floor( math.sqrt( p ) )
            while i <= rootP and prime do
                prime, i = p % i ~= 0, i + 1
            end
            return prime
        end
    end

    do  -- find the Wilson primes
        io.write( " n: Wilson primes\n" )
        io.write( "-----------------\n" )
        for n = 1, 11 do
            io.write( string.format( "%2d:", n ) )
            if isWilson( n, 2 ) then io.write( " 2" ) end
            for p = 3, maxPrime, 2 do
                if isprime( p ) then
                    if isWilson( n, p ) then io.write( " " .. p ) end
                end
            end
            io.write( "\n" )
        end
    end

end
