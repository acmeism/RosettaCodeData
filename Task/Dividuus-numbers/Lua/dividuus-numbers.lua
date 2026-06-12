do  -- find some Dividuus Numbers: numbers divisible by their digit sum, digit product,
    -- digital root and multiplicative root

    local function isDividuus( n )
        local absN <const> = math.abs( n )
        local v, sum, product = absN, 0, 1
        while v > 0 and product > 0 do
            local d <const> = v % 10
            v       = v // 10
            sum     = sum + d
            product = product * d
        end
        local dividuus = sum ~= 0 and product ~= 0
        if dividuus then
            dividuus = absN % sum == 0 and absN % product == 0
        end
        if dividuus then
            local mr = product
            while mr > 9 do
                local x = mr
                mr      = 1
                while x > 0 and mr > 0 do
                    mr = mr * ( x % 10 )
                    x  = x // 10
                end
            end
            dividuus = mr ~= 0
            if dividuus then dividuus = absN % mr == 0 end
        end
        if dividuus then
            local dr = sum
            while dr > 9 do
                local x = dr
                dr      = 0
                while x > 0 do
                    dr = dr + ( x % 10 )
                    x  = x // 10
                end
            end
            dividuus = dr ~= 0
            if dividuus then dividuus = absN % dr == 0 end
        end
        return dividuus
    end

    do -- task
        io.write( "First 50 Dividuus Numbers:\n" )
        local dCount, n = 0, 0
        while dCount < 50 do
            n = n + 1
            if isDividuus( n ) then
                io.write( string.format( " %5d", n ) )
                dCount = dCount + 1
                if dCount % 10 == 0 then io.write( "\n" ) end
            end
        end
        local lo <const>, hi <const> = 990000000, 1000000000
        io.write( string.format( "\nDividuus Numbers between %d and %d: ", lo, hi ) )
        for i = lo, hi do
            if isDividuus( i ) then
                io.write( string.format( "  %10d", i ) )
            end
        end
    end
end
