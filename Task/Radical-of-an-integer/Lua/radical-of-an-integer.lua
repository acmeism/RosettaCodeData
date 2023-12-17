do -- find the radicals of some integers - the radical of n is the product
   -- of the distinct prime factors of n, the radical of 1 is 1

    local maxNumber = 1000000;       -- maximum number we will consider
    local upfc, radical = {}, {}     -- unique prime factor counts and radicals
    for i = 1, maxNumber do
        upfc[    i ] = 0
        radical[ i ] = 1
    end
    for i = 2, maxNumber do
        if upfc[ i ] == 0 then
            radical[ i ] = i
            upfc[    i ] = 1
            for j = i + i, maxNumber, i do
                upfc[    j ] = upfc[    j ] + 1
                radical[ j ] = radical[ j ] * i
            end
        end
    end
    -- show the radicals of the first 50 positive integers
    io.write( "Radicals of 1 to 50:\n" )
    for i = 1, 50 do
        io.write( string.format( "%5d", radical[ i ] ), ( i % 10 == 0 and "\n" or "" ) )
    end
    -- radicals of some specific numbers
    io.write( "\n" )
    io.write( "Radical of  99999: ", radical[  99999 ], "\n" )
    io.write( "Radical of 499999: ", radical[ 499999 ], "\n" )
    io.write( "Radical of 999999: ", radical[ 999999 ], "\n" )
    io.write(  "\n" )
    -- show the distribution of the unique prime factor counts
    local dpfc = {}
    for i = 1, maxNumber do
        local count = dpfc[ upfc[ i ] ]
        dpfc[ upfc[ i ] ] = ( count == null and 1 or count + 1 )
    end
    io.write( "Distribution of radicals:\n" )
    for i = 0, #dpfc do
        io.write( string.format( "%2d", i ), ": ", dpfc[ i ], "\n" )
    end
end
