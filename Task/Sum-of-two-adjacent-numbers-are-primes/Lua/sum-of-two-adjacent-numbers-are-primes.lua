do  -- find the first 20 primes which are n + ( n + 1 ) for some n
    -- ( that's all the odd ones as all odd integers are n + n + 1 for some n, see the Phix sample )
    local pCount, p = 0, 1       -- number of primes found so far and starting position for prime search
    while pCount < 20 do
        p = p + 2
        -- check p is prime - trial division
        local isPrime, f = true, 3
        while f * f <= p and isPrime do
            isPrime = p % f ~= 0
            f = f + 2
        end
        if isPrime then
            local n <const> = p // 2
            pCount = pCount + 1
            io.write( string.format( " %2d + %2d = %2d\n", n, n + 1, p ) )
        end
    end
end
