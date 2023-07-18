-- Find the first 20 antiprimes.

-- returns a table of the first goal antiprimes
function antiprimes(goal)
    local maxNumber        = 0
    local ndc              = {} -- table of divisor counts - initially empty
    local list, number, mostFactors = {}, 1, 0
    while #list < goal do
        if number > #ndc then
            -- need a bigger table of divisor counts
            maxNumber = maxNumber + 5000
            ndc       = {}
            for i = 1, maxNumber do ndc[ i ] = 1 end
            for i = 2, maxNumber do
                for j = i, maxNumber, i do ndc[ j ] = ndc[ j ] + 1 end
            end
        end
        local factors = ndc[ number ]
        if factors > mostFactors then
            table.insert( list, number )
            mostFactors = factors
        end
        number = number + 1
    end
    return list
end

-- display the antiprimes
oo.write( table.concat( antiprimes( 20 ), " " ) )
