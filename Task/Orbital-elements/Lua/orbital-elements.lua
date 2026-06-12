do -- orbital elements

    local function Vector( x, y, z )
        return { x = x, y= y, z = z }
    end

    local function add( v, w )
        return Vector( v.x + w.x, v.y + w.y, v.z + w.z )
    end

    local function mul( v, m )
        return Vector( v.x * m, v.y * m, v.z * m )
    end

    local function div( v, d )
        return mul( v, 1.0 / d )
    end

    local function vabs( v )
        return math.sqrt( v.x * v.x + v.y * v.y + v.z * v.z )
    end

    local function mulAdd( v1,  v2,  x1,  x2 )
        return add( mul( v1, x1 ), mul( v2, x2 ) )
    end

    local function vecAsStr( v )
        return string.format( "(%.17g", v.x )..string.format( ", %.17g", v.y )..string.format( ", %.17g)", v.z )
    end

    local function rotate( i,  j, alpha )
        return mulAdd( i, j,  math.cos( alpha ), math.sin( alpha ) )
             , mulAdd( i, j, -math.sin( alpha ), math.cos( alpha ) )
    end

    local function orbitalStateVectors( semimajorAxis, eccentricity, inclination
                                      , longitudeOfAscendingNode, argumentOfPeriapsis
                                      , trueAnomaly
                                      )

        local i, j, k = Vector( 1.0, 0.0, 0.0 ), Vector( 0.0, 1.0, 0.0 ), Vector( 0.0, 0.0, 1.0 )
        local L = 2.0
        i, j = rotate( i, j, longitudeOfAscendingNode )
        j, _ = rotate( j, k, inclination )
        i, j = rotate( i, j, argumentOfPeriapsis )
        if eccentricity ~= 1.0 then L = 1.0 - eccentricity * eccentricity end
        L = L * semimajorAxis
        local c, s = math.cos( trueAnomaly ), math.sin( trueAnomaly )
        local r = L / ( 1.0 + eccentricity * c )
        local rprime   = s * r * r / L;
        local position = mul( mulAdd( i, j, c, s ), r )
        local speed    = mulAdd( i, j, rprime * c - r * s, rprime * s + r * c )
        speed = div( speed, vabs( speed ) )
        speed = mul( speed, math.sqrt( 2.0 / r - 1.0 / semimajorAxis ) )
        return position, speed
    end

    local longitude = 355.0 / ( 113.0 * 6.0 )
    local position, speed = orbitalStateVectors( 1.0, 0.1, 0.0, longitude, 0.0, 0.0 )
    print( "Position : "..vecAsStr( position ) )
    print( "Speed    : "..vecAsStr( speed    ) )
end
