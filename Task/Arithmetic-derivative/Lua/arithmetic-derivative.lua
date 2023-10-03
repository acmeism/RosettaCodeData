do    local function lagarias (n) -- Lagarias arithmetic derivative
           if n < 0
           then return -lagarias (-n)
           elseif n == 0 or n == 1
           then return 0
           else local function smallPf (j, k) -- Smallest prime factor
                    if j % k == 0 then return k else return smallPf (j, k + 1) end
                end
                local f = smallPf (n, 2) local q = math.floor (n / f)
                if q == 1
                then return 1
                else return q * lagarias (f) + f * lagarias (q)
                end
           end
      end
      for n = -99,100
      do io.write (string.format("%6d", lagarias (n)))
         if n % 10 == 0 then io.write ("\n") end
      end
      io.write ("\n")
      for n = 1,17     -- 18, 19 and 20 would overflow
      do local m = 10 ^ n
         io.write ("D(", string.format ("%d", m), ") / 7 = ", math.floor (lagarias (m) / 7), "\n")
      end
end
