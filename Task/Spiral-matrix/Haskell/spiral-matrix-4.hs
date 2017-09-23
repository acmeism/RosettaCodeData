import Data.List (transpose)

spiral :: Int -> Int -> Int -> [[Int]]
spiral rows cols start =
  if rows > 0
    then [start .. start + cols - 1] :
         (reverse <$> transpose (spiral cols (rows - 1) (start + cols)))
    else [[]]

main :: IO ()
main = mapM_ print $ spiral 5 5 0
