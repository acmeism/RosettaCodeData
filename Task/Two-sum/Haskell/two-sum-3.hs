sumTo :: Int -> [Int] -> [(Int, Int)]
sumTo n ns =
  let ixs = zip [0 ..] ns
  in [ (i, j)
     | (i, x) <- ixs
     , (j, y) <- drop (succ i) ixs
     , (x + y) == n ]

main :: IO ()
main = mapM_ print $ sumTo 21 [0, 2, 11, 19, 90, 10]
