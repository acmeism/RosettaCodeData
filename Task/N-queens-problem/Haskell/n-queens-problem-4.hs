import Data.List (intercalate, transpose)

--------------------- N QUEENS PROBLEM -------------------

queenPuzzle :: Int -> Int -> [[Int]]
queenPuzzle nRows nCols
  | nRows <= 0 = [[]]
  | otherwise =
      foldr
        (\x y -> y <> foldr (go x) [] [1 .. nCols])
        []
        $ queenPuzzle (pred nRows) nCols
  where
    go qs iCol b
      | safe (nRows - 1) iCol qs = b <> [qs <> [iCol]]
      | otherwise = b

safe :: Int -> Int -> [Int] -> Bool
safe iRow iCol qs =
  (not . or) $
    zipWith
      ( \sc sr ->
          (iCol == sc) || (sc + sr == (iCol + iRow))
            || (sc - sr == (iCol - iRow))
      )
      qs
      [0 .. iRow - 1]

--------------------------- TEST -------------------------
-- 10 columns of solutions for the 7*7 board:
showSolutions :: Int -> Int -> [String]
showSolutions nCols nSize =
  unlines
    . fmap (intercalate "   ")
    . transpose
    . map boardLines
    <$> chunksOf nCols (queenPuzzle nSize nSize)
  where
    go r x
      | r == x = '♛'
      | otherwise = '.'
    boardLines rows =
      [ go r <$> [1 .. (length rows)]
        | r <- rows
      ]

chunksOf :: Int -> [a] -> [[a]]
chunksOf i = splits
  where
    splits [] = []
    splits l = take i l : splits (drop i l)

main :: IO ()
main = (putStrLn . unlines) $ showSolutions 10 7
