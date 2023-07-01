import Data.List (genericTake, genericLength)
import Data.Bits (shiftR)

powMod :: Integer -> Integer -> Integer -> Integer
powMod m b e = go b e 1
  where
    go b e r
      | e == 0 = r
      | odd e  = go ((b*b) `mod` m) (e `div` 2) ((r*b) `mod` m)
      | even e = go ((b*b) `mod` m) (e `div` 2) r

legendre :: Integer -> Integer -> Integer
legendre a p = powMod p a ((p - 1) `div` 2)

tonelli :: Integer -> Integer -> Maybe (Integer, Integer)
tonelli n p | legendre n p /= 1 = Nothing
tonelli n p =
  let s = length $ takeWhile even $ iterate (`div` 2) (p-1)
      q = shiftR (p-1) s
  in if s == 1
    then let r = powMod p n ((p+1) `div` 4)
         in Just (r, p - r)
    else let z = (2 +) . genericLength
               $ takeWhile (\i -> p - 1 /= legendre i p)
               $ [2..p-1]
         in loop s
            ( powMod p z q )
            ( powMod p n $ (q+1) `div` 2 )
            ( powMod p n q )
  where
    loop m c r t
      | (t - 1) `mod` p == 0 = Just (r, p - r)
      | otherwise =
        let i = (1 +) . genericLength . genericTake (m - 2)
              $ takeWhile (\t2 -> (t2 - 1) `mod` p /= 0)
              $ iterate (\t2 -> (t2*t2) `mod` p)
              $ (t*t) `mod` p
            b = powMod p c (2^(m - i - 1))
            r' = (r*b)  `mod` p
            c' = (b*b)  `mod` p
            t' = (t*c') `mod` p
        in loop i c' r' t'
