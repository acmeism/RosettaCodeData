for n = 1, 100 do -- show the largest proper divisors for n = 1..100
    local largestProperDivisor, j = 1, math.floor( n / 2 )
    while j >= 2 and largestProperDivisor == 1 do
        if n % j == 0 then
            largestProperDivisor = j
        end
        j = j - 1
    end
    io.write( string.format( "%3d", largestProperDivisor ) )
    if n % 10 == 0 then io.write( "\n" ) end
end
