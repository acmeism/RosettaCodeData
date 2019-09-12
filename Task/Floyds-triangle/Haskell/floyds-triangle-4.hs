floyd :: [Int] -> [Int]
floyd xs
  | n < 2 = [1]
  | otherwise = [succ (div (n * pred n) 2) .. div (n * succ n) 2]
  where
    n = succ (length xs)

floydN :: Int -> [[Int]]
floydN n = take n (iterate floyd [1])

main :: IO ()
main = mapM_ print $ floydN 5
