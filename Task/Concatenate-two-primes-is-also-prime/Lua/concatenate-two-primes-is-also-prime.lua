do -- find primes whose decimal representation is the concatenation of 2 primes < 100
    local MAX_PRIME = 99 * 99
    -- returns true if n is prime, false otherwise, uses trial division
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
    local concatPrime = {}
    -- tables of small primes, sp2 will be the final digits so does not include 2 or 5
    local sp1 = {  2,  3,  5,  7, 11, 13, 17, 19, 23, 29, 31, 37
                , 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
                }
    local sp2 = {      3,      7, 11, 13, 17, 19, 23, 29, 31, 37
                , 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97
                }
    -- find the concatenated primes
    for i = 1, MAX_PRIME do concatPrime[ i ] = false end
    for     _, p1 in pairs( sp1 ) do
        for _, p2 in pairs( sp2 ) do
            local pc = ( p1 * ( p2 < 10 and 10 or 100 ) ) + p2
            concatPrime[ pc ] = isPrime( pc )
        end
    end
    -- print the concatenated primes
    local cCount = 0
    for i = 1, MAX_PRIME do
        if concatPrime[ i ] then
           io.write( string.format( "%5d", i ) )
           cCount = cCount + 1
           if cCount % 10 == 0 then io.write( "\n" ) end
        end
    end
    io.write( "\n\nFound ", cCount, " concat primes" )
end
