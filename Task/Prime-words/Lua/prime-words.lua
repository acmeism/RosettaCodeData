do  -- find words whose character codes are primes

    local primeCh <const> = {}    -- table indicating whether ascii characters are prime
    for ch = 0, 255 do
        if     ch < 3      then primeCh[ ch ] = ch == 2
        elseif ch % 2 == 0 then primeCh[ ch ] = false
        else
            local isPrime, k = true, 3
            while k * k <= ch and isPrime do
                isPrime, k = ch % k ~= 0, k + 2
            end
            primeCh[ ch ] = isPrime
        end
    end

    local function isAPrimeWord( line )
        local result = true
        for c = 1, # line do
            local cCode = line:byte( c )
            result = cCode <= # primeCh and primeCh[ cCode ] or false
            if not result then break end
        end
        return result
    end

    local pwCount = 0
    for line in io.lines( "unixdict.txt" ) do
        if isAPrimeWord( line ) then
            pwCount = pwCount + 1
            io.write( " "..line )
            if pwCount % 20 == 0 then print() end
        end
    end

end
