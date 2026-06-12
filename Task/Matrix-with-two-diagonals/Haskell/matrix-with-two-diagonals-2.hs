-------------- MATRIX WITH TWO DIAGONALS ---------------

twoDiagonalMatrix :: Int -> [[Int]]
twoDiagonalMatrix n =
  let xs = [1 .. n]
   in [ [ fromEnum $ x `elem` [y, succ (n - y)]
          | x <- xs
        ]
        | y <- xs
      ]

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    unlines . fmap (((' ' :) . show) =<<)
      . twoDiagonalMatrix
      <$> [7, 8]
