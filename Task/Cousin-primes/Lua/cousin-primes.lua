do -- find primes p where p+4 is also prime
    local MAX_PRIME = 1000
    local p = {}    -- sieve the odd primes to MAX_PRIME
    for i = 3, MAX_PRIME, 2 do p[ i ] = true end
    for i = 3, math.floor( math.sqrt( MAX_PRIME ) ), 2 do
        if p[ i ] then
            for s = i * i, MAX_PRIME, i + i do p[ s ] = false end
        end
    end
    local function fmt ( n ) return string.format( "%3d", n ) end
    io.write( "Cousin primes under ", MAX_PRIME, ":\n" )
    local cCount = 0
    for i = 3, MAX_PRIME - 4, 2 do
        if p[ i ] and p[ i + 4 ] then
            cCount = cCount + 1
            io.write( "[ ", fmt( i ), " ", fmt( i + 4 ), " ]"
                    , ( cCount % 8 == 0 and "\n" or " " )
                    )
        end
    end
    io.write( "\nFound ", cCount, " cousin primes\n" )
end
