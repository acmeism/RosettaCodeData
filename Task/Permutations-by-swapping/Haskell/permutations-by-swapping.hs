s_permutations :: [a] -> [([a], Int)]
s_permutations = flip zip (cycle [1, -1]) . (foldl aux [[]])
  where aux items x = do
          (f,item) <- zip (cycle [reverse,id]) items
          f (insertEv x item)
        insertEv x [] = [[x]]
        insertEv x l@(y:ys) = (x:l) : map (y:) (insertEv x ys)

main :: IO ()
main = do
  putStrLn "3 items:"
  mapM_ print $ s_permutations [0..2]
  putStrLn "4 items:"
  mapM_ print $ s_permutations [0..3]
