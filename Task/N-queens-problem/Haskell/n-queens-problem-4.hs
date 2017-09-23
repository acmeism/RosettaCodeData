import Data.List (transpose, intercalate)

queenPuzzle :: Int -> Int -> [[Int]]
queenPuzzle nRows nCols
  | nRows <= 0 = [[]]
  | otherwise =
    foldr
      (\solution a ->
          a ++
          foldr
            (\iCol b ->
                if safe (nRows - 1) iCol solution
                  then b ++ [solution ++ [iCol]]
                  else b)
            []
            [1 .. nCols])
      []
      (queenPuzzle (nRows - 1) nCols)
  where
    safe iRow iCol solution =
      True `notElem`
      zipWith
        (\sc sr ->
            (iCol == sc) || (sc + sr == iCol + iRow) || (sc - sr == iCol - iRow))
        solution
        [0 .. iRow - 1]

-- TEST ------------------------------------------------------------------------
-- 10 columns of solutions for the 7*7 board:
showSolutions :: Int -> Int -> [String]
showSolutions nCols nBoardSize =
  unlines <$>
  (((intercalate "   " <$>) . transpose . (boardLines <$>)) <$>
   chunksOf nCols (queenPuzzle nBoardSize nBoardSize))
  where
    boardLines rows =
      (\r -> foldMap (\c -> if_ (c == r) "♛" ".") [1 .. (length rows)]) <$> rows

chunksOf :: Int -> [a] -> [[a]]
chunksOf i xs = take i <$> ($ (:)) (splits xs) []
  where
    splits [] _ n = []
    splits l c n = l `c` splits (drop i l) c n

if_ :: Bool -> a -> a -> a
if_ True x _ = x
if_ False _ y = y

main :: IO ()
main = mapM_ putStrLn $ showSolutions 10 7
