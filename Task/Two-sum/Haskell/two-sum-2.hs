sumTo :: Int -> [Int] -> [(Int, Int)]
sumTo n ns =
  let ixs = zip [0 ..] ns
   in ixs
        >>= ( \(i, x) ->
                drop (succ i) ixs
                  >>= \(j, y) ->
                    [ (i, j)
                      | (x + y) == n
                    ]
            )

main :: IO ()
main = mapM_ print $ sumTo 21 [0, 2, 11, 19, 90, 10]
