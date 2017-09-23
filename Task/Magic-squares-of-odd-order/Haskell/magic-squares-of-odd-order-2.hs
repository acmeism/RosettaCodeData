import Data.List (transpose, unfoldr, intercalate)
import Data.List.Split (chunksOf)

magicSquare :: Int -> [[Int]]
magicSquare n =
  case mod n 2 of
    1 ->
      (transpose .
       cycledRows .
       transpose . cycledRows . (chunksOf <*> (enumFromTo 1 . (^ 2))))
        n
    _ -> []

-- Table of integers -> Table with rows rotated by descending deltas
cycledRows :: [[Int]] -> [[Int]]
cycledRows rows =
  let n = length rows
      d = quot n 2
  in zipWith
       (\d xs -> take n $ drop (n - d) (cycle xs))
       [d,subtract 1 d .. -d]
       rows

main :: IO ()
main =
  putStr $
  intercalate "\n\n" ((unlines . fmap show . magicSquare) <$> [3, 5, 7])
