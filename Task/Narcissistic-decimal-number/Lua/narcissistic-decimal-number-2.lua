do
    -- print the first 25 narcissistic numbers

    local power      = { [0] = 0, 1, 2, 3, 4, 5, 6, 7, 8, 9 }
    local count      = 0
    local candidate  = 0
    local prevDigits = 0
    local digits     = 0

    for d9 = 0, 2 do
        if d9 > 0 and digits < 9 then digits = 9 end
        for d8 = 0, 9 do
            if d8 > 0 and digits < 8 then digits = 8 end
            for d7 = 0, 9 do
                if d7 > 0 and digits < 7 then digits = 7 end
                for d6 = 0, 9 do
                    if d6 > 0 and digits < 6 then digits = 6 end
                    for d5 = 0, 9 do
                        if d5 > 0 and digits < 5 then digits = 5 end
                        for d4 = 0, 9 do
                            if d4 > 0 and digits < 4 then digits = 4 end
                            for d3 = 0, 9 do
                                if d3 > 0 and digits < 3 then digits = 3 end
                                for d2 = 0, 9 do
                                    if d2 > 0 and digits < 2 then digits = 2 end
                                    for d1 = 0, 9 do

                                        if prevDigits ~= digits then
                                            -- number of digits has increased
                                            -- - increase the powers
                                            prevDigits = digits
                                            for i = 2, 9 do power[ i ] = power[ i ] * i end
                                        end

                                        -- sum the digits'th powers of the
                                        -- digits of candidate
                                        local sum = power[ d1 ] + power[ d2 ] + power[ d3 ]
                                                  + power[ d4 ] + power[ d5 ] + power[ d6 ]
                                                  + power[ d7 ] + power[ d8 ] + power[ d9 ]
                                        if candidate == sum then
                                            -- found another narcissistic
                                            -- decimal number
                                            io.write( " ", candidate )
                                            count = count + 1
                                            if count >= 25 then io.write( "\n" ); os.exit() end
                                        end
                                        candidate = candidate + 1
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    io.write( "\n" )

end
