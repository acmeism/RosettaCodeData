import Data.Bits

isqrt :: Integer -> Integer
isqrt n = go n 0 (q `shiftR` 2)
 where
   q = head $ dropWhile (< n) $ iterate (`shiftL` 2) 1
   go z r 0 = r
   go z r q = let t = z - r - q
              in if t >= 0
                 then go t (r `shiftR` 1 + q) (q `shiftR` 2)
                 else go z (r `shiftR` 1) (q `shiftR` 2)

main = do
  print $ isqrt <$> [1..65]
  mapM_ print $ zip [1,3..73] (isqrt <$> iterate (49 *) 7)
