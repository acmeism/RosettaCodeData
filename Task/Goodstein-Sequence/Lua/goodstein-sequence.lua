do  -- Goodstein sequence - translation of Phix via EasyLang

    local function bump( v, b )
        local n, res = v, 0
        local i = 0
        while n > 0 do
            local d <const> = n % b
            if d > 0 then
                res = res + d * math.floor( ( ( b + 1 ) ^ bump( i, b ) ) + 0.5 )
            end
            n = n // b
            i = i + 1
        end
        return res
    end

    local function goodstein( n, maxterms )
        local res <const> = {}
        if maxterms > 0 then
            res[ # res + 1 ] = n
            while # res < maxterms and res[ # res ] ~= 0 do
                res[ # res + 1 ] = bump( res[ # res ], # res + 1 ) - 1
            end
        end
        return res
    end

    do
        for i = 0, 7 do
            print( "[ " .. table.concat( goodstein( i, 10 ), " " ) .. " ]" )
        end
        print();
        for i = 0, 10 do
            local h = goodstein( i, i + 1 )
            print( h[ # h ] )
        end
    end
end
