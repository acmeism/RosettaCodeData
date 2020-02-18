mult :: Num a => [[a]] -> [[a]] -> [[a]]
mult uss vss =
  map
    ((\xs ->
         if null xs
           then []
           else foldl1 (zipWith (+)) xs) .
     zipWith (flip (map . (*))) vss)
    uss

main :: IO ()
main = mapM_ print $ mult [[1, 2], [3, 4]] [[-3, -8, 3], [-2, 1, 4]]
