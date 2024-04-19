do  -- show some Stirling numbers of the second kind
    local MAX_STIRLING = 12;
    -- construct a matrix of Stirling numbers up to max n, max n
    local s2 = {}
    for n = 0, MAX_STIRLING do
        s2[ n ] = {}
        for k = 0, MAX_STIRLING do s2[ n ][ k ] = 0 end
    end
    for n = 0, MAX_STIRLING     do s2[ n ][ n ] = 1 end
    for n = 0, MAX_STIRLING - 1 do
        for k = 1, n do
            s2[ n + 1 ][ k ] = k * s2[ n ][ k ] + s2[ n ][ k - 1 ]
        end
    end
    io.write( "Stirling numbers of the second kind:\n" )
    io.write( " k" )
    for k = 0, MAX_STIRLING do io.write( string.format( "%8d", k ) ) end
    io.write( "\n" )
    io.write( " n\n" );
    for n = 0, MAX_STIRLING do
        io.write( string.format( "%2d", n ) )
        for k = 0, n do io.write( string.format( "%8d", s2[ n ][ k ] ) ) end
        io.write( "\n" )
    end
end
