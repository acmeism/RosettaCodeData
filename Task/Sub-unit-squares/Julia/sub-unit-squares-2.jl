# find some sub-unit squares: squares which are still squares when 1
# is subtracted from each of their digits
# the sub-unit squares must end in 36 (see task discussion) and so
# the square formed by subtracting 1 from each digit must end in 25
# so, as with the J sample, we start with the "25" square and test
# the incremented square

begin # find the sub unit squares - note that 1 is a special case
    local maxCount  =  7
    local suSquares = collect( 1 : maxCount ) # array initially 1, 2, 3, ...
    local suCount   =  1
    local addOnes   =  1
    local powerOf10 = 10
    local n         = -5
    while suCount < maxCount
        n += 10
        sq = n^2
        while sq > powerOf10
            # the square has more digits than the previous one
            powerOf10 *= 10
            addOnes   *= 10
            addOnes   +=  1
        end
        addUnitSq = sq + addOnes
        if addUnitSq < powerOf10
            # squaring the number with one added to the digits has the
            # same number of digits as the original square
            local root = isqrt( addUnitSq )
            if root^2 == addUnitSq
                # the addUnitSquare is actually a square
                # make sure there are no 0s in the addUnitSquare as they
                # can't be decremented to a positive digit
                if all( x -> x != 0, digits( addUnitSq ) )
                    suCount += 1
                    suSquares[ suCount ] = addUnitSq
                end
            end
        end
    end
    println( suSquares )
end
