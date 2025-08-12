do
    function totient( n ) -- returns the number of integers k where 1 <= k <= n that are mutually prime to n
        if     n <  3 then return 1
        elseif n == 3 then return 2
        else
           local result, v, i = n, n, 2
           while i * i <= v do
               if v % i == 0 then
                   while v % i == 0 do v = math.floor( v / i ) end
                   result = result - math.floor( result / i )
               end
               if i == 2 then
                   i = 1
               end
               i = i + 2
           end
           if v > 1 then result = result - math.floor( result / v ) end
           return result
       end
    end
    -- show the totient function values for the first 25 integers
    io.write( " n  phi(n) remarks\n" )
    for n = 1,25 do
        local tn = totient( n )
        io.write( string.format( "%2d: %5d%s\n", n, tn, ( tn == n - 1 and tn ~= 0 and "  n is prime" or "" ) ) )
    end
    -- use the totient function to count primes
    local n100, n1_000, n10_000, n100_000 = 0, 0, 0, 0
    for n = 1,100000 do
        if totient( n ) == n - 1 then
            if n <=    100 then     n100 = n100     + 1 end
            if n <=   1000 then   n1_000 = n1_000   + 1 end
            if n <=  10000 then  n10_000 = n10_000  + 1 end
            if n <= 100000 then n100_000 = n100_000 + 1 end
        end
    end
    io.write( string.format( "There are %6d primes below      100\n",     n100 ) )
    io.write( string.format( "There are %6d primes below    1 000\n",   n1_000 ) )
    io.write( string.format( "There are %6d primes below   10 000\n",  n10_000 ) )
    io.write( string.format( "There are %6d primes below  100 000\n", n100_000 ) )
end
