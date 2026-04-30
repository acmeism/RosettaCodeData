do  -- Find numbers with equal rises and falls between the digits

    -- returns true if the number of digits in n followed by a higher digit (rises)
    --              equals the number of digits followed by a lower digit (falls)
    --        false otherwise
    local function equalRisesAndFalls( n )
        local rf, prev, v = 0, n % 10, n // 10
        while v > 0 do
            local d <const> = v % 10
            if d < prev then
                rf = rf + 1   -- rise
            elseif d > prev then
                rf = rf - 1   -- fall
            end
            prev, v = d, v // 10
        end
        return rf == 0
    end

    do -- task test cases

        local maxCount <const> = 10000000
        local count, n = 0, 0

        io.write( "The first 200 numbers in the sequence are:\n" )
        while count < maxCount do
            n = n + 1
            if equalRisesAndFalls( n ) then
                count = count + 1
                if count <= 200 then
                    io.write( string.format( "%4d", n ) )
                    if count % 20 == 0 then io.write( "\n" ) end
                elseif count == maxCount then
                    io.write( string.format( "\nThe 10 millionth number in the sequence is %8d.\n", n ) )
                end
            end
        end
    end
end
