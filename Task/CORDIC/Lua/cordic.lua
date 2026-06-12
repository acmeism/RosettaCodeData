do -- implement sin, cos and tan using the CORDIC algorithm

    local piBy2 = math.pi / 2

    -- pre-computed table of arctan(10^-n) values
    local theta = { 7.85398163397448e-01, 9.96686524911620e-02
                  , 9.99966668666524e-03, 9.99999666666867e-04
                  , 9.99999996666667e-05, 9.99999999966667e-06
                  , 9.99999999999667e-07, 9.99999999999997e-08
                  , 1.00000000000000e-08, 1.00000000000000e-09
                  , 1.00000000000000e-10, 1.00000000000000e-11
                  , 1.00000000000000e-12, 1.00000000000000e-13
                  , 1.00000000000000e-14, 1.00000000000000e-15
                  , 1.00000000000000e-16
                  }
    local epsilon = 1e-16

    --[[ CORDIC algorithm, finds "y" and "x" for alpha radians
         signs indicates the sign of the results:
               signs[ 1 ] = sign for -π : -π/2, signs[ 1 ] = sign for -π/2 : 0
               signs[ 3 ] = sign for  0 :  π/2, signs[ 4 ] = sign for  π/2 : π
         signBoth = TRUE => sign applied to both y and x, FALSE => sign y only
    --]]
    function cordic( alphaIn, signs, signBoth )
        local alpha     = alphaIn
        -- ensure -π <= alpha <= π
        local flipSign = false
        while alpha < - math.pi do alpha = alpha + math.pi flipSign = not flipSign end
        while alpha >   math.pi do alpha = alpha - math.pi flipSign = not flipSign end
        local sign
        if    alpha < - piBy2 then
            alpha = alpha + math.pi
            sign = signs[ 1 ]
        elseif  alpha < 0     then
            alpha = - alpha
            sign = signs[ 2 ]
        elseif  alpha < piBy2 then
            sign = signs[ 3 ]
        else -- alpha <= math.pi
            alpha = math.pi - alpha
            sign = signs[ 4 ]
        end
        if flipSign and signBoth then sign = -sign end
        local x, y, k, tenToMinusK = 1, 0, 1, 1 -- NB: tenToMinusK is 10^-(k-1)
        while epsilon < alpha do
            while alpha < theta[ k ] do
                k           = k +  1
                tenToMinusK = tenToMinusK / 10
            end
            alpha = alpha - theta[ k ]
            x, y = x - tenToMinusK * y, y + tenToMinusK * x
        end
        return sign * y, signBoth and sign * x or x
    end

    -- cos(alpha) using the CORDIC algorithm. alpha in radians
    function cCos( alpha )
        local y, x = cordic( alpha, { -1, 1, 1, -1 }, true )
        return x / math.sqrt( ( x * x ) + ( y * y ) )
    end

    -- sin(alpha) using the CORDIC algorithm. alpha in radians
    function cSin( alpha )
        local y, x = cordic( alpha, { -1,-1, 1, 1 }, true )
        return y / math.sqrt( ( x * x ) + ( y * y ) )
    end

    -- tan(alpha) using the CORDIC algorithm. alpha in radians
    function cTan( alpha )
        local y, x  = cordic( alpha, {  1, -1, 1,-1 }, false )
        return x == 0 and NaN or y / x
    end

    function f6( v ) return string.format( " %9.6f", v ) end
    function g(  v ) return string.format( " %12g",  v ) end

    function showCordic( angle )
        local cosine,  cordicCos = math.cos( angle ), cCos( angle )
        local sine,    cordicSin = math.sin( angle ), cSin( angle )
        local tangent, cordicTan = math.tan( angle ), cTan( angle )
        local cDiff  = cordicCos - cosine  if cDiff < 0 then cDiff = - cDiff end
        local sDiff  = cordicSin - sine    if sDiff < 0 then sDiff = - sDiff end
        local tDiff  = cordicTan - tangent if tDiff < 0 then tDiff = - tDiff end
        io.write( string.format( "%4.1f: ", angle )
                , f6( cordicCos ), f6( cosine  ), g( cDiff ), " |"
                , f6( cordicSin ), f6( sine    ), g( sDiff ), " |"
                , f6( cordicTan ), f6( tangent ), g( tDiff ), "\n"
                )
    end

    local tests = { -9, 0, 1.5, 6 }
    io.write( "angle cordic cos       cos   difference" )
    io.write(     "  cordic sin       sin   difference" )
    io.write(     "  cordic tan       tan   difference" )
    io.write( "\n" )
    for i = 1, # tests do
        showCordic( tests[ i ] )
    end
    io.write( "angle cordic cos       cos   difference" )
    io.write(     "  cordic sin       sin   difference" )
    io.write(     "  cordic tan       tan   difference" )
    io.write( "\n" )
    for i = 7810, 7891, 9 do
        showCordic( i / 10000 )
    end

end
