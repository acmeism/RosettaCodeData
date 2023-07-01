integerFactors :: Int -> [Int]
integerFactors n
  | 1 > n = []
  | otherwise = lows <> (quot n <$> part n (reverse lows))
  where
    part n
      | n == square = tail
      | otherwise = id
    (square, lows) =
      (,) . (^ 2)
        <*> (filter ((0 ==) . rem n) . enumFromTo 1)
        $ floor (sqrt $ fromIntegral n)

main :: IO ()
main = print $ integerFactors 600
