do --[[ find steady squares - numbers whose square ends in the number
         e.g.: 376^2 = 141 376
   --]]

    -- checks wheher n^2 mod p10 = n, i.e. n is a steady square and displays
    --        a message if it is
    local function possibleSteadySuare ( n, p10 )
        if ( n * n ) % p10 == n then
            print( string.format( "%4d^2: %d", n, n * n ) )
        end
    end

    local powerOfTen = 10

    -- note the final digit must be 1, 5 or 6
    for p = 0,10000,10 do
        if p == powerOfTen then
            -- number of digits has increased
            powerOfTen = powerOfTen * 10
        end
        possibleSteadySuare( p + 1, powerOfTen )
        possibleSteadySuare( p + 5, powerOfTen )
        possibleSteadySuare( p + 6, powerOfTen )
    end
end
