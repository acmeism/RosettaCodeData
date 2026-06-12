binom :: Int -> Int -> Int
binom n k
  | min n k < 0 = 0
  | otherwise = factorial n `div` (factorial k * factorial (n - k))
  where
    factorial n = product [1..n]

bern_tri :: Int -> [Int]
bern_tri n = tail $ scanl (\accum x -> accum + binom n x) 0 [0..n]

main = mapM_ print (map bern_tri [0..14])
