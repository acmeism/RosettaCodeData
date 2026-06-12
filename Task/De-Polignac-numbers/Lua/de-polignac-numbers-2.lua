do  -- find some De Polignac Numbers - positive odd numbers that can't be
    -- written as p + 2^n for some prime p and integer n
    -- Translated from the Pluto ssample

    function erato(n) -- modified sieve function from the Sieve of Eratosthenes taks
      local t = {false} -- 1 is not prime
      local sqrtlmt = math.sqrt(n)
      for i = 2, n
        do t[i] = true
      end
      for i = 2, sqrtlmt do
        if t[i] then
          for j = i*i, n, i do
            t[j] = false
          end
        end
      end
      return t
    end

    local maxNumber = 500000                   -- maximum number we will consider
    local isPrime   = erato( maxNumber )       -- sieve of primes to maxNumber

    -- table of powers of 2 greater than 2^0 ( up to around 2 000 000 )
    --       increase maxPower if maxNumber > 2 000 000
    local powersOf2, maxPower = {}, 20
    do
        local p2 = 1
        for i = 1, maxPower do
            p2 = p2 * 2
            powersOf2[ i ] = p2
        end
    end
    -- the numbers must be odd and not of the form p + 2^n
    -- either p is odd and 2^n is even and hence n > 0 and p > 2
    --     or 2^n is odd and p is even and hence n = 0 and p = 2
    local dp = {}
    -- n = 0, p = 2 - the only possibility is 3
    for i = 1, 3, 2 do
        local p = 2
        if p + 1 ~= i then
           table.insert( dp, i )
        end
    end
    -- n > 0, p > 2
    for i = 5, maxNumber, 2 do
        local found = false
        for p = 1, # powersOf2 do
            if found or i <= powersOf2[ p ] then break end
            found = isPrime[ i - powersOf2[ p ] ]
        end
        if not found then
            table.insert( dp, i )
        end
    end
    for i = 1, 50 do
        io.write( string.format( "%5d", dp[ i ] ) )
        if i % 10 == 0 then io.write( "\n" ) end
    end
    io.write( string.format( "The %5dth De Polignac number is %7d\n",    1000, dp[  1000 ] ) )
    io.write( string.format( "The %5dth De Polignac number is %7d\n",   10000, dp[ 10000 ] ) )
    io.write( string.format( "Found %5d De Polignac numbers up to %d\n", # dp, maxNumber ) )
end
