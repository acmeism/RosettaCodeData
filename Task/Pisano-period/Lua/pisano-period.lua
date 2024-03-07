do -- find the Pisano period of some primes and composites

    local maxNumber = 180
    -- sieve the primes to maxNumber
    local isPrime = {}
    for i = 1, maxNumber do isPrime[ i ] = i % 2 ~= 0 end
    isPrime[ 1 ]  = false
    isPrime[ 2 ]  = true
    for s = 3, math.floor( math.sqrt( maxNumber ) ), 2 do
        if isPrime[ s ] then
            for p = s * s, maxNumber, s do isPrime[ p ] = false end
        end
    end

    local function pisano( m ) -- returns the Pisano period of m
        local p, c = 0, 1
        for i = 0, ( m * m ) - 1 do
            p, c = c, ( p + c ) % m
            if p == 0 and c == 1 then return i + 1 end
        end
        return 1
    end

    -- returns the Pisano period of p^k or 0 if p is not prime or k < 1
    local function pisanoPrime( p, k )
         return ( not isPrime[ p ] or k < 1 ) and 0 or math.floor( p ^ ( k - 1 ) * pisano( p ) )
    end

    local function d4( n ) -- returns n formatted in 4 characcters
        return string.format( "%4d", n )
    end

    io.write( "Pisano period of p^2 where p is a prime < 15:\n" )
    for p = 1, 15 do
        if isPrime[ p ] then io.write( " "..p..":"..pisanoPrime( p, 2 ) ) end
    end
    io.write( "\nPisano period of primes up to 180, non-primes shown as \"*\":\n" )
    for p = 1, 180 do
        io.write( not isPrime[ p ] and "   *" or d4( pisanoPrime( p, 1 ) ) )
        if p % 10 == 0 then io.write( "\n" ) end
    end
    io.write( "\nPisano period of positive integers up to 180:\n" )
    for n = 1, 180 do
        io.write( d4( pisano( n ) ) )
        if n % 10 == 0 then io.write( "\n" ) end
    end

end
