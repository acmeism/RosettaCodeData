do -- find some factorial primes - primes that are f - 1 or f + 1
   --      for some factorial f

    function isPrime( p )
        if p <= 1 or p % 2 == 0 then
            return p == 2
        else
            local prime = true
            local i     = 3
            local rootP = math.floor( math.sqrt( p ) )
            while i <= rootP and prime do
                prime = p % i ~= 0
                i     = i + 2
            end
            return prime
        end
    end

    local f       = 1
    local fpCount = 0
    local n       = 0
    local fpOp    = ""
    while fpCount < 10 do
        n    = n + 1
        f    = f * n
        fpOp = "-"
        for fp = f - 1, f + 1, 2 do
            if isPrime( fp ) then
                fpCount = fpCount + 1
                io.write( string.format( "%2d", fpCount  ), ":"
                        , string.format( "%4d", n        ), "! "
                        , fpOp, " 1 = ", fp, "\n"
                        )
            end
            fpOp = "+"
        end
    end

end
