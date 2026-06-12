do -- find the centroid of some N-dimensional points

    function centroid( points ) -- returns the centroid of points
         local result = {}
         if #points > 0 then
             for j = 1, #points[ 1 ] do
                 local sum = 0
                 for i = 1, #points do sum = sum + points[ i ][ j ] end
                 result[ j ] = sum / #points
             end
         end
         return result
    end

    function show1d( v ) -- show a 1D array of floats
        io.write( "[" )
        for i = 1, #v do io.write( " ", v[ i ] ) end
        io.write( " ]" )
    end
    function show2d( v ) -- show a 2D array of floats
        io.write( "[" )
        for i = 1 , #v do show1d( v[ i ] ) end
        io.write( "]" )
    end

    -- task test cases

    function testCentroid( points )
         show2d( points )
         io.write( "   -> " )
         show1d( centroid( points ) )
         io.write( "\n" )
    end

    testCentroid{ { 1 }, { 2 }, { 3 } }
    testCentroid{ { 8, 2 }, { 0, 0 } }
    testCentroid{ { 5, 5, 0 }, { 10, 10, 0 } }
    testCentroid{ {  1, 3.1, 6.5 }, { -2, -5, 3.4 }
                , { -7,  -4, 9   }, {  2,  0,   3 }
                }
    testCentroid{ { 0, 0, 0, 0, 1 }, { 0, 0, 0, 1, 0 }
                , { 0, 0, 1, 0, 0 }, { 0, 1, 0, 0, 0 }
                }
end
