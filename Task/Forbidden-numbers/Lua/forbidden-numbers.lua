do
    local isForbidden = function( n )
          local m, p4 = n, 1
          while m > 1 and m % 4 == 0 do
              m, p4 = ( m // 4 ), p4 * 4
          end
          return ( n // p4 ) % 8 == 7
    end
    local fCount, nextToShow = 0, 500
    for i = 1, 50000000 do
        if isForbidden( i ) then
            fCount = fCount + 1
            if fCount <= 50 then
                io.write( string.format( " %3d", i ) )
                if fCount % 10 == 0 then io.write( "\n" ) end
            end
        end
        if i == nextToShow then
            io.write( "There are "..string.format( "%8d", fCount ).." Forbidden numbers up to "..i.."\n" )
            nextToShow = nextToShow * 10
        end
    end
end
