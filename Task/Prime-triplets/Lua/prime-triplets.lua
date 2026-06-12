do -- find primes p where p+2 and p+6 are also prime
    local MAX_PRIME = 5500
    local pList = {}
    do -- set pList to a list of primes up to MAX_PRIME
        -- sieve the odd primes to n and construct the list
        local p = {}
        for i = 3, MAX_PRIME, 2 do p[ i ] = true end
        for i = 3, math.floor( math.sqrt( MAX_PRIME ) ), 2 do
            if p[ i ] then
                for s = i * i, MAX_PRIME, i + i do p[ s ] = false end
            end
        end
        pList[ 1 ] = 2
        for i = 3, MAX_PRIME, 2 do
            if p[ i ] then pList[ #pList + 1 ] = i end
        end
    end
    local function fmt ( n ) return string.format( "%4d", n ) end
    io.write( "Prime triplets under ", MAX_PRIME, ":", "\n" )
    local tCount = 0
    for i = 1, #pList - 2 do
        local p1, p2, p3 = pList[ i ], pList[ i + 1 ], pList[ i + 2 ]
        if  p2 - p1 == 2 and p3 - p2 == 4 then
            tCount = tCount + 1
            io.write( "[ ", fmt( p1 ), " ", fmt( p2 ), " ", fmt( p3 ), " ]"
                    , ( tCount % 5 == 0 and "\n" or " " )
                    )
        end
    end
    io.write( "\n", "Found ", tCount, " prime triplets\n" )
end
