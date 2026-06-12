do  -- find idoneal numbers - numbers that cannot be written as ab + bc + ac
    --                        where 0 < a < b < c
    -- there are 65 known idoneal numbers
    local maxCount = 65
    local count, n =  0, 0
    while count < maxCount do
        n = n + 1
        local idoneal, a = true, 1
        while ( a + 2 ) < n and idoneal do
            local b = a + 1
            repeat
                local ab, sum = a * b, 0
                if ab < n then
                    local c = math.floor( ( n - ab ) / ( a + b ) )
                    sum     = ab + ( c * ( b + a ) )
                    if c > b and sum == n then
                        idoneal = false
                    end
                    b = b + 1
                end
            until sum > n or not idoneal or ab >= n
            a = a + 1
        end
        if idoneal then
            count = count + 1
            io.write( string.format( " %4d", n ) )
            if count % 13 == 0 then io.write( "\n" ) end
        end
    end
end
