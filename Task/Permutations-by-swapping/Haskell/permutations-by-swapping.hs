sPermutations :: [a] -> [([a], Int)]
sPermutations = flip zip (cycle [-1, 1]) . foldr aux [[]]
  where
    aux x items = do
      (f, item) <- zip (repeat id) items
      f (insertEv x item)
    insertEv x [] = [[x]]
    insertEv x l@(y:ys) = (x : l) : ((y :) <$> insertEv x ys)

main :: IO ()
main = do
  putStrLn "3 items:"
  mapM_ print $ sPermutations [1 .. 3]
  putStrLn "\n4 items:"
  mapM_ print $ sPermutations [1 .. 4]
