do --[[ find some incomsummate numbers: integers that cannot be expressed as
             an integer divided by the sum of its digits
   --]]

    local maxConsummate = 999999
    local consummate = {}    -- table of numbers that can be formed by n / digit sum n
    --[[ calculate the maximum number we must consider to find consummate numbers
         up to maxConsummate - which is 9 * the number of digits in maxConsummate
    --]]
    local maxSum = 9
    local v      = math.floor( maxConsummate / 10 )
    while v > 0 do
        maxSum = maxSum + 9
        v      = math.floor( v / 10 )
    end
    local maxNumber = maxConsummate * maxSum
    -- construct the digit sums of the numbers up to maxNumber and find the consumate numbers
    consummate[ 1 ] = true
    local tn, hn, th, tt, ht, mi, tm = 1, 0, 0, 0, 0, 0, 0
    for n = 10, maxNumber, 10 do
        local sumd = tm + mi + ht + tt + th + hn + tn
        for d = n, n + 9 do
            if d % sumd == 0 then  -- d is comsummate
                local dRatio = math.floor( d / sumd )
                if dRatio <= maxConsummate then
                    consummate[ dRatio ] = true
                end
            end
            sumd = sumd + 1
        end
        tn = tn + 1
        if tn > 9 then
            tn = 0
            hn = hn + 1
            if hn > 9 then
                hn = 0
                th = th + 1
                if th > 9 then
                    th = 0
                    tt = tt + 1
                    if tt > 9 then
                        tt = 0
                        ht = ht + 1
                        if ht > 9 then
                            ht = 0
                            mi = mi + 1
                            if mi > 9 then
                                mi = 0
                                tm = tm + 1
                            end
                        end
                    end
                end
            end
        end
    end
    local count = 0
    io.write( "The first 50 inconsummate numbers:\n" )
    for i = 1, maxConsummate do
        if count >= 100000 then break end
        if not consummate[ i ] then
            count = count + 1
            if count < 51 then
                io.write( string.format( "%6d", i ), ( count % 10 == 0 and "\n" or "" ) )
            elseif count == 1000 or count == 10000 or count == 100000 then
                io.write( "Inconsummate number ", string.format( "%6d", count )
                        , ": ", string.format( "%8d", i ), "\n"
                        )
            end
        end
    end
end
