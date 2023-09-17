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
        io.write( string.format( "%2d", n ), ": ", string.format( "%5d", tn )
                , ( tn == n - 1 and tn ~= 0 and "  n is prime" or "" )
                , "\n"
                )
    end
    -- use the totient function to count primes
    local n100, n1000, n10000, n100000 = 0, 0, 0, 0
    for n = 1,100000 do
        if totient( n ) == n - 1 then
            if n <=    100 then    n100 = n100    + 1 end
            if n <=   1000 then   n1000 = n1000   + 1 end
            if n <=  10000 then  n10000 = n10000  + 1 end
            if n <= 100000 then n100000 = n100000 + 1 end
        end
    end
    io.write( "There are ", string.format( "%6d",    n100 ), " primes below      100\n" )
    io.write( "There are ", string.format( "%6d",   n1000 ), " primes below    1 000\n" )
    io.write( "There are ", string.format( "%6d",  n10000 ), " primes below   10 000\n" )
    io.write( "There are ", string.format( "%6d", n100000 ), " primes below  100 000\n" )
end
