import Control.Arrow ((&&&))

integerFactors :: Int -> [Int]
integerFactors n
  | n < 1 = []
  | otherwise =
    lows ++
    (quot n <$>
     (if intSquared == n -- A perfect square,
        then tail        -- and cofactor of square root would be redundant.
        else id)
       (reverse lows))
  where
    (intSquared, lows) =
      (^ 2) &&& (filter ((0 ==) . rem n) . enumFromTo 1) $
      floor (sqrt $ fromIntegral n)

main :: IO ()
main = print $ integerFactors 600
