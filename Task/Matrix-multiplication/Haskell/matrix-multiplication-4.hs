mult :: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss =
  let go xs
        | null xs = []
        | otherwise = foldl1 (zipWith (+)) xs
   in go . zipWith (flip (map . (*))) vss <$> uss

main :: IO ()
main =
  mapM_ print $
    mult [[1, 2], [3, 4]] [[-3, -8, 3], [-2, 1, 4]]
