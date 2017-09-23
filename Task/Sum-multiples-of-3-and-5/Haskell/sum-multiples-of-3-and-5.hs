import Data.List (nub)

sum35 :: Integral a => a -> a
sum35 n = sumMul n 3 + sumMul n 5 - sumMul n 15

sumMul :: Integral a => a -> a -> a
sumMul n f = f * n1 * (n1 + 1) `div` 2
  where
    n1 = (n - 1) `div` f

-- Functions below are for variable length inputs

pairLCM :: Integral a => [a] -> [a]
pairLCM [] = []
pairLCM (x:xs) = (lcm x <$> xs) ++ pairLCM xs

sumMulS :: Integral a => a -> [a] -> a
sumMulS _ [] = 0
sumMulS n s = sum (sumMul n <$> ss) - sumMulS n (pairLCM ss)
  where
    ss = nub s

main :: IO ()
main =
  mapM_
    print
    [ sum35 1000
    , sum35 100000000000000000000000000000000
    , sumMulS 1000 [3, 5]
    , sumMulS 10000000 [2, 3, 5, 7, 11, 13]
    ]
