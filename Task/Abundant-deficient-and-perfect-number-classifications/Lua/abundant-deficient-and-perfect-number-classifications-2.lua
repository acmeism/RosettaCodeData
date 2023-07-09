do -- classify the numbers 1 : 20 000 as abudant, deficient or perfect
    local abundantCount    = 0
    local deficientCount   = 0
    local perfectCount     = 0
    local maxNumber        = 20000
    -- construct a table of the proper divisor sums
    local pds              = {}
    pds[ 1 ] = 0
    for i = 2, maxNumber do pds[ i ] = 1 end
    for i = 2, maxNumber do
        for j = i + i, maxNumber, i do pds[ j ] = pds[ j ] + i end
    end
    -- classify the numbers
    for n = 1, maxNumber do
        local   pdSum = pds[ n ]
        if      pdSum <  n then
            deficientCount    = deficientCount + 1
        elseif  pdSum == n then
            perfectCount      = perfectCount + 1
        else -- pdSum >  n
            abundantCount     = abundantCount + 1
        end
    end
    io.write( "abundant  ",  abundantCount, "\n" )
    io.write( "deficient ", deficientCount, "\n" )
    io.write( "perfect   ",   perfectCount, "\n" )
end
