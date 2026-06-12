do -- Riordan numbers

    local function riordan( n ) -- returns a table of the Riordan numbers 0 .. n
        local  a = {}
        if n >= 0 then
            a[ 0 ] = 1
            if n >= 1 then
                a[ 1 ] = 0
                for i = 2, n do
                    a[ i ] = math.floor( ( ( i - 1 )
                                         * ( ( 2 * a[ i - 1 ] )
                                           + ( 3 * a[ i - 2 ] )
                                           )
                                         )
                                       / ( i + 1 )
                                       )
                end
            end
        end
        return a
    end
    local function commatise( unformatted ) -- returns a string representation of n with commas
        local result, chCount = "", 0
        for c = #unformatted, 1, -1 do
            if chCount <= 2 then
                chCount = chCount + 1
            else
                chCount = 1
                result = ( unformatted:sub( c, c ) == " " and " " or "," )..result
            end
            result = unformatted:sub( c, c )..result
        end
        return result
    end

    do -- show the first 32 Riordann numbers
        local r, shown = riordan( 31 ), 0
        for i = 0, #r do
            shown = ( shown + 1 ) % 4
            io.write( commatise( string.format( "%15d", r[ i ] ) )
                    , ( shown == 0 and "\n" or "" )
                    )
        end
    end
end
