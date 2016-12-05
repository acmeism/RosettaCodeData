import Data.List (transpose, intercalate)

magicSquare :: Int -> [[Int]]
magicSquare n = rowCycles . transpose . rowCycles $ rangeSquare n
  where

    -- N * N square with cells numbered sequentially
    -- left right, top down

    rangeSquare :: Int -> [[Int]]
    rangeSquare n = rowsOf n [1..(n^2)]
      where
        rowsOf _ [] = []
        rowsOf m xs = row : rowsOf n rest
          where
            (row, rest) = splitAt n xs


    -- Numbers in each row cycled to the right
    -- The first row by (N div 2) cells, and each subsequent row
    -- by one less, down to minus (N div 2) in the last row

    rowCycles :: [[Int]] -> [[Int]]
    rowCycles rows =
        uncurry listCycle <$> zip [d, d-1 .. -d] rows
          where
            d = quot (length rows) 2
            listCycle _ [] = []
            listCycle n xs =
                zipWith const (drop (length xs - n) (cycle xs)) xs

-- TEST
-- Magic squares of dimension 3, 5 and 7

main :: IO ()
main =  putStr $ intercalate "\n\n" $
    (\n -> (intercalate "\n" $ show <$> magicSquare n)) <$> [3, 5, 7]
