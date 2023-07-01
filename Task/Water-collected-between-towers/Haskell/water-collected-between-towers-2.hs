import Data.List (replicate, transpose)

-------------- WATER COLLECTED BETWEEN TOWERS ------------

towerPools :: [Int] -> [(Int, Int)]
towerPools =
  zipWith min . scanl1 max <*> scanr1 max
    >>= zipWith ((<*>) (,) . (-))


--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    (putStrLn . display . towerPools)
    [ [1, 5, 3, 7, 2],
      [5, 3, 7, 2, 6, 4, 5, 9, 1, 2],
      [2, 6, 3, 5, 2, 8, 1, 4, 2, 2, 5, 3, 5, 7, 4, 1],
      [5, 5, 5, 5],
      [5, 6, 7, 8],
      [8, 7, 7, 6],
      [6, 7, 10, 7, 6]
    ]

------------------------- DIAGRAMS -----------------------

display :: [(Int, Int)] -> String
display = (<>) . showTowers <*> (('\n' :) . showLegend)

showTowers :: [(Int, Int)] -> String
showTowers xs =
  let upper = maximum (fst <$> xs)
   in '\n' :
      ( unlines
          . transpose
          . fmap
            ( \(x, d) ->
                concat $
                  replicate (upper - (x + d)) " "
                    <> replicate d "x"
                    <> replicate x "█"
            )
      )
        xs

showLegend :: [(Int, Int)] -> String
showLegend =
  ((<>) . show . fmap fst)
    <*> ((" -> " <>) . show . foldr ((+) . snd) 0)
