amicablePairsUpTo :: Int -> [(Int, Int)]
amicablePairsUpTo n =
  foldl
    (\a x ->
        let y = sigma x
        in if (x < y) && (sigma y == x)
             then a ++ [(x, y)]
             else a)
    []
    [1 .. n]

sigma :: Int -> Int
sigma = sum . propDivs
  where
    propDivs :: Int -> [Int]
    propDivs n
      | n < 2 = []
      | otherwise =
        lows ++
        drop
          (if isPerfect
             then 1
             else 0)
          (reverse (quot n <$> tail lows))
      where
        iRoot = floor (sqrt $ fromIntegral n)
        isPerfect = iRoot * iRoot == n
        lows = filter ((== 0) . rem n) [1 .. iRoot]

main :: IO ()
main = mapM_ print $ amicablePairsUpTo 20000
