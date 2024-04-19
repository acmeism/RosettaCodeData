do  -- show some (unsigned) Stirling numbers of the first kind
    local MAX_STIRLING = 12
    -- construct a matrix of Stirling numbers up to max n, max n
    local s1 = {}
    for n = 0, MAX_STIRLING do
        s1[ n ] = {}
        for k = 0, MAX_STIRLING do s1[ n ][ k ] = 0 end
    end
    s1[ 0 ][ 0 ] = 1
    for n = 1, MAX_STIRLING do s1[ n ][ 0 ] = 0 end
    for n = 1, MAX_STIRLING do
        for k = 1, n do
            local s1Term = ( ( n - 1 ) * s1[ n - 1 ][ k ] )
            s1[ n ][ k ] = s1[ n - 1 ][ k - 1 ] + s1Term
        end
    end
    io.write( "Unsigned Stirling numbers of the first kind:\n" )
    io.write( " k  0" )
    for k = 1, MAX_STIRLING do
        io.write( string.format( ( k < 6 and "%10d" or "%9d" ), k ) )
    end
    io.write( "\n" )
    io.write( " n\n" );
    for n = 0, MAX_STIRLING do
        io.write( string.format( "%2d", n ), string.format( "%3d", s1[ n ][ 0 ] ) )
        for k = 1, n do
            io.write( string.format( ( k < 6 and "%10d" or "%9d" ), s1[ n ][ k ] ) )
        end
        io.write( "\n" )
    end
end
