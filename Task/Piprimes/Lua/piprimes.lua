do  -- Show some values of pi(n) - the number of priems <= n

    local function is_prime( n )
        local result = n == 2 or ( n % 2 == 1 and n > 1 )
        if result then
            for k = 3, math.floor( math.sqrt( n ) ), 2 do
                if not result then break end
                result = n % k ~= 0
            end
        end
        return result
    end

    local maxPrime <const>, maxCount <const> = 100, 21
    local pCount = 0
    for p = 1, maxPrime do
        if is_prime( p ) then
            pCount = pCount + 1
            if pCount > maxCount then break end
        end
        io.write( string.format( " %2d", pCount ) )
        if p % 10 == 0 then print() end
    end

end
