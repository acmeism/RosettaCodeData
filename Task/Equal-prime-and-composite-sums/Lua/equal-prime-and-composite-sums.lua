do --[[ find n and m where the sums of the first n primes and first m
        composites where the sums are equal
   --]]

    local function isPrime( n )         -- returns TRUE if n is prime
         if   n <= 2 then return n == 2
         elseif n % 2 == 0 then return false
         else local prime, i, r = true, 1, math.floor( math.sqrt( n ) )
              repeat
                  i = i + 2
                  if i <= r then
                       prime = n % i ~= 0
                  end
              until i > r or not prime
              return prime
         end
    end

    local  count, n, m, sumP, sumC, numP, numC = 0, 2, 1, 5, 4, 3, 4
    io.write( "           sum    primes composites\n" )

    repeat
        if sumC > sumP then
            repeat numP = numP + 2 until isPrime( numP )
            sumP = sumP + numP
            n    = n + 1
        end
        if sumP > sumC then
            repeat numC = numC + 1 until not isPrime( numC )
            sumC = sumC + numC
            m    = m + 1
        end
        if sumP == sumC then
            io.write( string.format( "%14d", sumP ), string.format( "%10d", n ), string.format( "%11d", m ), "\n" )
            count = count + 1;
            if count < 8 then
                repeat numC = numC + 1 until not isPrime( numC )
                sumC = sumC + numC
                m    = m + 1
            end
        end
    until count >= 8
end
