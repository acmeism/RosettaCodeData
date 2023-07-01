import Data.List (nub)

----------------- SUM MULTIPLES OF 3 AND 5 ---------------

sum35 :: Integer -> Integer
sum35 n = f 3 + f 5 - f 15
  where
    f = sumMul n

sumMul :: Integer -> Integer -> Integer
sumMul n f = f * n1 * (n1 + 1) `div` 2
  where
    n1 = (n - 1) `div` f


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    print
    [ sum35 1000,
      sum35 100000000000000000000000000000000,
      sumMulS 1000 [3, 5],
      sumMulS 10000000 [2, 3, 5, 7, 11, 13]
    ]

---------------- FOR VARIABLE LENGTH INPUTS --------------

pairLCM :: [Integer] -> [Integer]
pairLCM [] = []
pairLCM (x : xs) = (lcm x <$> xs) <> pairLCM xs

sumMulS :: Integer -> [Integer] -> Integer
sumMulS _ [] = 0
sumMulS n s =
  ( ((-) . sum . fmap f)
      <*> (g . pairLCM)
  )
    (nub s)
  where
    f = sumMul n
    g = sumMulS n
