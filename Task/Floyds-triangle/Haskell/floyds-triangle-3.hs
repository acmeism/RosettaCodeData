----------------- LINES OF FLOYDS TRIANGLE ---------------

floyds :: [[Int]]
floyds = iterate floyd [1]

floyd :: [Int] -> [Int]
floyd xs
  | n < 2 = [1]
  | otherwise =
    [ succ (div (n * pred n) 2)
      .. div (n * succ n) 2
    ]
  where
    n = succ (length xs)


--------------------------- TEST -------------------------
main :: IO ()
main = do
  mapM_ print $ take 5 floyds
  putStrLn ""
  mapM_ print $ take 14 floyds
