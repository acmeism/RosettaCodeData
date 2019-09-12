import Data.List (transpose, intercalate)
import Data.Bool (bool)

queenPuzzle :: Int -> Int -> [[Int]]
queenPuzzle nRows nCols
  | nRows <= 0 = [[]]
  | otherwise =
    foldr
      (\qs a ->
          a ++
          foldr
            (\iCol b -> bool b (b ++ [qs ++ [iCol]]) (safe (nRows - 1) iCol qs))
            []
            [1 .. nCols])
      []
      (queenPuzzle (nRows - 1) nCols)

safe :: Int -> Int -> [Int] -> Bool
safe iRow iCol qs =
  (not . or) $
  zipWith
    (\sc sr ->
        (iCol == sc) || (sc + sr == (iCol + iRow)) || (sc - sr == (iCol - iRow)))
    qs
    [0 .. iRow - 1]

-- TEST ---------------------------------------------------
-- 10 columns of solutions for the 7*7 board:
showSolutions :: Int -> Int -> [String]
showSolutions nCols nSize =
  unlines <$>
  ((fmap (intercalate "   ") . transpose . fmap boardLines) <$>
   chunksOf nCols (queenPuzzle nSize nSize))
  where
    boardLines rows =
      (\r -> (bool '.' '♛' . (== r)) <$> [1 .. (length rows)]) <$> rows

chunksOf :: Int -> [a] -> [[a]]
chunksOf i xs = take i <$> ($ (:)) (splits xs) []
  where
    splits [] _ n = []
    splits l c n = l `c` splits (drop i l) c n

main :: IO ()
main = (putStrLn . unlines) $ showSolutions 10 7
