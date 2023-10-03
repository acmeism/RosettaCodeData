do  -- find the first five rare numbers

    local function revn ( na )
        local n, r = na, 0
        while n > 0 do
            r = r * 10   r = r + ( n % 10 )
            n = math.floor( n / 10 )
        end
        return r
    end -- revn

    local nd, count, lim, n = 2, 0, 90, 20
    local oddNd = nd % 2 == 1
    while true do
        n = n + 1
        local r = revn( n )
        if  r < n then
            local s, d = n + r, n - r
            local tryThis = false
            if   oddNd
            then tryThis = d % 1089 == 0
            else tryThis = s %  121 == 0
            end
            if tryThis then
                local rootS = math.sqrt( s )
                if  rootS == math.floor(rootS )
                then
                    local rootD = math.sqrt( d )
                    if    rootD == math.floor( rootD )
                    then
                        count = count + 1
                        io.write( count, ": ", n, "\n" )
                        if count >= 5 then os.exit() end
                    end
                end
            end
            if  n == lim
            then
                lim   = lim * 10
                nd    = nd  +  1
                oddNd = not oddNd
                n     = math.floor( lim / 9 ) * 2
            end
        end
    end
end
