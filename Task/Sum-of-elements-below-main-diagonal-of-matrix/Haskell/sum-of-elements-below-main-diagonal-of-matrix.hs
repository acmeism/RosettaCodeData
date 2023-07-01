----------------- UPPER OR LOWER TRIANGLE ----------------

matrixTriangle :: Bool -> [[a]] -> Either String [[a]]
matrixTriangle upper matrix
  | upper = go drop id
  | otherwise = go take pred
  where
    go f g
      | isSquare matrix =
        (Right . snd) $
          foldr
            (\xs (n, rows) -> (pred n, f n xs : rows))
            (g $ length matrix, [])
            matrix
      | otherwise = Left "Defined only for a square matrix."

isSquare :: [[a]] -> Bool
isSquare rows = all ((n ==) . length) rows
  where
    n = length rows

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    zipWith
      ( flip ((<>) . (<> " triangle:\n\t"))
          . either id (show . sum . concat)
      )
      ( [matrixTriangle] <*> [False, True]
          <*> [ [ [1, 3, 7, 8, 10],
                  [2, 4, 16, 14, 4],
                  [3, 1, 9, 18, 11],
                  [12, 14, 17, 18, 20],
                  [7, 1, 3, 9, 5]
                ]
              ]
      )
      ["Lower", "Upper"]
