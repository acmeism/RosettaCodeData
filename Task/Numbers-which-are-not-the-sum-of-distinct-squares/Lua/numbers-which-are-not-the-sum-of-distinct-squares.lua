do  --[[ find the integers that can't be expressed as the sum of distinct squares
         it can be proved that if 120-324 can be expressed as the sum of distinct squares
         then all integers greater than 129 can be so expressed (see the link in
         the Wren sample) so we need to check that 129-324 can be so expressed
         and find the numbers below 129 that can't be so expressed
    --]]
    local maxNumber = 324
    local isSum     = {}
    local maxSquare = math.floor( math.sqrt( 324 ) )
    local square    = {} for i = 0,maxSquare do square[ i ] = i * i end

    local function flagSum ( currSum, sqPos )
         local nextSum = currSum + square[ sqPos ]
         if nextSum <= maxNumber then
            isSum[ nextSum ] = true
            for i = sqPos + 1, maxSquare do
                flagSum( nextSum, i )
            end
         end
    end

    for i = 0,maxSquare do
        flagSum( 0, i )
    end
    --[[ show the numbers that can't be formed from a sum of distinct squares
         and check 129-324 can be so formed
    --]]
    local unformable = 0
    for i = 0, maxNumber do
        if not isSum[ i ] then
            io.write( string.format( "%4d", i ) )
            unformable = unformable + 1
            if unformable % 12 == 0 then io.write( "\n" ) end
            if i > 128 then
                io.write( "\n", "**** unexpected unformable number: ", i, "\n" )
            end
        end
    end
end
