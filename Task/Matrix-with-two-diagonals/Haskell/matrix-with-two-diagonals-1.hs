---------------- MATRIX WITH TWO DIAGONALS ---------------

twoDiagonalMatrix :: Int -> [[Int]]
twoDiagonalMatrix n = flip (fmap . go) xs <$> xs
  where
    xs = [1 .. n]
    go x y
      | y == x = 1
      | y == succ (subtract x n) = 1
      | otherwise = 0

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ putStrLn $
    unlines . fmap (((' ' :) . show) =<<)
      . twoDiagonalMatrix
      <$> [7, 8]
