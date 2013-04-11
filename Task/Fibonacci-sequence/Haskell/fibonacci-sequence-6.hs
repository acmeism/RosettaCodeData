fibsteps (a,b) n
    | n <= 0 = (a,b)
    | True   = fibsteps (b, a+b) (n-1)

fibnums :: [Integer]
fibnums = map fst $ iterate (`fibsteps` 1) (0,1)

fibN2 :: Integer -> (Integer, Integer)
fibN2 m | m < 10 = fibsteps (0,1) m
fibN2 m          = fibN2_next (n,r) (fibN2 n)
                     where (n,r) = quotRem m 3

fibN2_next (n,r) (f,g) | r==0 = (a,b)    -- 3n  ,3n+1
                       | r==1 = (b,c)    -- 3n+1,3n+2
                       | r==2 = (c,d)    -- 3n+2,3n+3   (*)
  where
      a = ( 5*f^3 + if even n then 3*f else (- 3*f) ) -- 3n
      d = ( 5*g^3 + if even n then (- 3*g) else 3*g ) -- 3(n+1)   (*)
      b = (   g^3 + 3 * g * f^2 - f^3               ) -- 3n+1
      c = (   g^3 + 3 * g^2 * f + f^3               ) -- 3n+2
