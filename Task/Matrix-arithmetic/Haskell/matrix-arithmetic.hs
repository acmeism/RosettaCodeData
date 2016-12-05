s_permutations :: [a] -> [([a], Int)]
s_permutations = flip zip (cycle [1, -1]) . (foldl aux [[]])
  where aux items x = do
          (f,item) <- zip (cycle [reverse,id]) items
          f (insertEv x item)
        insertEv x [] = [[x]]
        insertEv x l@(y:ys) = (x:l) :  map (y:) (insertEv x ys)

elemPos::[[a]] -> Int -> Int -> a
elemPos ms i j = (ms !! i) !! j

prod:: Num a => ([[a]] -> Int -> Int -> a) -> [[a]] -> [Int] -> a
prod f ms = product.zipWith (f ms) [0..]

s_determinant:: Num a => ([[a]] -> Int -> Int -> a) -> [[a]] -> [([Int],Int)] -> a
s_determinant f ms = sum.map (\(is,s) -> fromIntegral s * prod f ms is)

determinant:: Num a => [[a]] -> a
determinant ms = s_determinant elemPos ms.s_permutations $ [0..pred.length $ ms]

permanent:: Num a => [[a]] -> a
permanent ms = sum.map (prod elemPos ms.fst).s_permutations $ [0..pred.length $ ms]

result ms = do
  putStrLn "Matrice:"
  mapM_ print ms
  putStrLn "Determinant:"
  print $ determinant ms
  putStrLn "Permanent:"
  print $ permanent ms

main = do
  let m1 = [[5]]
  let m2 = [[1,0,0],[0,1,0],[0,0,1]]
  let m3 = [[0,0,1],[0,1,0],[1,0,0]]
  let m4 = [[4,3],[2,5]]
  let m5 = [[2,5],[4,3]]
  let m6 = [[4,4],[2,2]]
  mapM_ result [m1,m2,m3,m4,m5,m6]
