do -- Rice encoding  - translation of the Julia sample

    -- Golomb-Rice encoding of a positive number to a bit vector (string of 0s and 1s) using M of 2^k
    local function rice_encode( n, k )
        assert( n >= 0 )
        k = k or 2
        local m = math.floor( 2^k )
        local result, q, r = {}, math.floor( n / m ), n % m
        while r > 0 do
            result[ #result + 1 ] = r % 2 == 0 and "0" or "1"
            r = math.floor( r / 2 )
        end
        while #result < k do result[ #result + 1 ] = "0" end
        result[ #result + 1 ] = "0"
        for i = 1, q do result[ #result + 1 ] = "1" end
        return string.reverse( table.concat( result, "" ) )
    end
    -- see wikipedia.org/wiki/Golomb_coding#Use_with_signed_integers
    local function extended_rice_encode( n, k )
        k = k or 2
        local n2 = 2 * n
        return rice_encode( n < 0 and -n2 - 1 or n2, k )
    end

    -- Golomb-Rice decoding of a bit vector (string of 0s and 1s) with M of 2^k
    local function rice_decode( a, k )
        k = k or 2
        local m = math.floor( 2^k )
        local zpos, _ = a:find( "0" )
        local r = 0
        for z = zpos, #a do
            r = r * 2
            if a:sub( z, z ) == "1" then r = r + 1 end
        end
        local q = zpos - 1
        return q * m + r
    end

    local function extended_rice_decode( a, k )
        k = k or 2
        local i = rice_decode( a, k )
        return math.floor( i % 2 == 1 and - ( ( i + 1 ) / 2 ) or i / 2 )
    end

    print( "Base Rice Coding:" )
    for n = 0, 10 do
        local e = rice_encode( n )
        print( n.." -> "..e.." -> "..rice_decode( e ) )
    end
    print( "Extended Rice Coding:" )
    for n = -10, 10 do
        local e = extended_rice_encode( n )
        print( n.." -> "..e.." -> "..extended_rice_decode( e ) )
    end

end
