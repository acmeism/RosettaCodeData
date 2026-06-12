do  -- find numbers whose hex representation does not contain the digits 0-9

    -- generate and print the numbers up to 499
    -- 499 is 1F3 in hex, so we need to find numbers up to FF

    local hCount = 0

    -- 1 hex digit numbers
    for d1 = 10, 15 do
        io.write( "  " .. d1 )
        hCount = hCount + 1
    end

    -- two hex digit numbers
    for d1 = 10, 15 do
        for d2 = 10, 15 do
            io.write( " " .. ( ( d1 * 16 ) + d2 ) )
            hCount = hCount + 1
            if hCount % 12 == 0 then print() end
        end
    end
end
