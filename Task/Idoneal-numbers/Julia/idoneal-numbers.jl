begin # find idoneal numbers - numbers that cannot be written as ab + bc + ac
      #                        where 0 < a < b < c
      # there are 65 known idoneal numbers
    local count    =  0
    local maxCount = 65
    local n        =  0
    local iNumbers = collect( 1 : maxCount )
    while count < maxCount
        n += 1
        local idoneal = true
        local a       = 1
        while ( a + 2 ) < n && idoneal
            local b = a + 1
            while true
                local ab  = a * b
                local sum = 0
                if ab < n
                    local c = ( n - ab ) ÷ ( a + b )
                    sum     = ab + ( c * ( b + a ) )
                    if c > b && sum == n
                        idoneal = false
                    end
                    b += 1
                end
                if sum > n || idoneal == 0 || ab >= n
                    break
                end
            end
            a += 1
        end
        if idoneal
            count += 1
            iNumbers[ count ] = n
        end
    end
    println( iNumbers )
end
