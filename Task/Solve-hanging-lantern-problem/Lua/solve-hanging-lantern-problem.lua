do  -- find the number of ways of taking down columns of lanterns
    -- translation of the Python "Math" sample via Pkuto

    local function factorial( n )
        local result, prev, fn = 1, 0, 0
        for i = 1, n do
            fn     = fn + 1
            result = result * fn
            if prev > result then
                error( "Overflow calculating "..n.."! (at "..i.."!)" )
            end
        end
        return result
    end

    local function getLantern( arr )
        local result, total = 0, 0
        for i = 1, # arr do
            total = total + arr[ i ]
        end
        result = factorial( total )
        for i = 1, # arr do
            result = result // factorial( arr[ i ] )
        end
        return result
    end

    do
        io.write( "Columns> " )
        local n, a = io.read( "n" ), {}
        io.write( "lanterns per column> " )
        for i = 1, n do
            a[ i ] = io.read( "n" )
        end
        print( getLantern( a ) )
    end
end
