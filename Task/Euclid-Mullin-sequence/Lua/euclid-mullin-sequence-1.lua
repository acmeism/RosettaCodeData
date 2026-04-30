-- find elements of the Euclid-Mullin sequence: starting from 2,
-- the next element is the smallest prime factor of 1 + the product
-- of the previous elements
do
    io.write( "2" )
    local product = 2
    for i = 2, 9 do
        local nextV, p, found = product + 1, 3, false
        -- find the first prime factor of nextV
        while  p * p <= nextV and not found do
            found = nextV % p == 0
            if not found then p = p + 2 end
        end
        if found then nextV = p end
        io.write( " ", nextV )
        product = product * nextV
    end
end
