do  -- find a sequence of primes where the members differ by a cube

    local maxPrime = 15000
    -- sieve the primes to maxPrime
    local isPrime = {}
    for i = 1, maxPrime do isPrime[ i ] = i % 2 ~= 0 end
    isPrime[ 1 ]  = false
    isPrime[ 2 ]  = true
    for s = 3, math.floor( math.sqrt( maxPrime ) ), 2 do
        if isPrime[ s ] then
            for p = s * s, maxPrime, s do isPrime[ p ] = false end
        end
    end

    -- construct a table of cubes, we will need at most the cube root of maxPrime
    local cube = {}
    for i = 1, math.floor( ( maxPrime ^ ( 1 / 3 ) ) ) do cube[ i ] = i * i * i end

    -- find the prime sequence
    io.write( "2" )
    local p = 2
    while p < maxPrime do
        -- find a prime that is p + a cube
        local q, i = 0, 1
        repeat
            q, i = p + cube[ i ], i + 1
        until q > maxPrime or isPrime[ q ]
        if q <= maxPrime then io.write( " ", q ) end
        p = q
    end
    io.write( "\n" )
end
