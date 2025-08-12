do  -- find some factorial primes - primes that are f - 1 or f + 1 for some factorial f

    local function isPrime( p )
        if p <= 1 or p % 2 == 0 then
            return p == 2
        else
            local prime, i, rootP = true, 3, math.floor( math.sqrt( p ) )
            while i <= rootP and prime do
                prime, i = p % i ~= 0, i + 1
            end
            return prime
        end
    end

    local f, fpCount, n = 1, 0, 1
    while fpCount < 10 do
        f = f * n
        local fpOp = "-"
        for fp = f - 1, f + 1, 2 do
            if isPrime( fp ) then
                fpCount = fpCount + 1
                io.write( string.format( "%2d:%4d! %s 1 = %d\n", fpCount, n, fpOp, fp ) )
            end
            fpOp = "+"
        end
        n = n + 1
    end

end
