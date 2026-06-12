do  --[[ find some sub-unit squares: squares which are still squares when 1
         is subtracted from each of their digits
         the sub-unit squares must end in 36 (see task discussion) and so
         the square formed by subtracting 1 from each digit must end in 25
         so, as with the J sample, we start with the "25" square and test
         the incremented square
    --]]
    -- find the sub unit squares - note that 1 is a special case
    io.write( "1" )
    local suCount   =  1
    local addOnes   =  1
    local powerOf10 = 10
    local n         = -5
    while suCount < 7 do
        n = n + 10
        local sq = n * n
        while sq > powerOf10 do
            -- the square has more digits than the previous one
            powerOf10 = powerOf10 * 10
            addOnes   = ( addOnes * 10 ) + 1
        end
        local addUnitSq = sq + addOnes
        if addUnitSq < powerOf10
        then
            -- squaring the number with one added to the digits has the
            -- same number of digits as the original square
            local root = math.floor( math.sqrt( addUnitSq ) )
            if root * root == addUnitSq
            then
                -- the addUnitSquare is actually a square
                -- make sure there are no 0s in the addUnitSquare as they
                -- can't be decremented to a positive digit
                local noZeros = true
                local v       = addUnitSq
                while v > 0 and noZeros do
                    noZeros = v % 10 ~= 0
                    v = math.floor( v / 10 )
                end
                if noZeros
                then
                    io.write( " ", addUnitSq )
                    suCount = suCount + 1
                end
            end
        end
    end
end
