do --[[ find the first 4 Giuga numbers, composites n such that all their
        distinct prime factors f exactly divide ( n / f ) - 1

        each prime factor must appear only once, e.g.: for 2:
        [ ( n / 2 ) - 1 ] mod 2 = 0  => n / 2 is odd => n isn't divisible by 4
        similarly for other primes
     ]]

    local gCount, n = 0, 2
    while gCount < 4 do
        n = n + 4                           -- assume the numbers are all even
        local fCount, f, isGiuga, v = 1, 1, true, math.floor( n / 2 )
        while f <= ( v - 2 ) and isGiuga do
            f = f + 2
            if v % f == 0 then                          -- have a prime factor
                fCount  = fCount + 1
                isGiuga = ( math.floor( n / f ) - 1 ) % f == 0
                v       = math.floor( v / f )
            end
        end
        if isGiuga then       -- n is still a candidate, check it is not prime
            if fCount > 1 then
                gCount = gCount + 1
                io.write( " ", n )
            end
        end
    end
end
