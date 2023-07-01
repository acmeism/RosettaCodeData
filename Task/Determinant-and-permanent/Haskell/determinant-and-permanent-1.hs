sPermutations :: [a] -> [([a], Int)]
sPermutations = flip zip (cycle [1, -1]) . foldl aux [[]]
  where
    aux items x = do
      (f, item) <- zip (cycle [reverse, id]) items
      f (insertEv x item)
    insertEv x [] = [[x]]
    insertEv x l@(y:ys) = (x : l) : ((y :) <$>) (insertEv x ys)

elemPos :: [[a]] -> Int -> Int -> a
elemPos ms i j = (ms !! i) !! j

prod
  :: Num a
  => ([[a]] -> Int -> Int -> a) -> [[a]] -> [Int] -> a
prod f ms = product . zipWith (f ms) [0 ..]

sDeterminant
  :: Num a
  => ([[a]] -> Int -> Int -> a) -> [[a]] -> [([Int], Int)] -> a
sDeterminant f ms = sum . fmap (\(is, s) -> fromIntegral s * prod f ms is)

determinant
  :: Num a
  => [[a]] -> a
determinant ms =
  sDeterminant elemPos ms . sPermutations $ [0 .. pred . length $ ms]

permanent
  :: Num a
  => [[a]] -> a
permanent ms =
  sum . fmap (prod elemPos ms . fst) . sPermutations $ [0 .. pred . length $ ms]

-- TEST -----------------------------------------------------------------------
result
  :: (Num a, Show a)
  => [[a]] -> String
result ms =
  unlines
    [ "Matrix:"
    , unlines (show <$> ms)
    , "Determinant:"
    , show (determinant ms)
    , "Permanent:"
    , show (permanent ms)
    ]

main :: IO ()
main =
  mapM_
    (putStrLn . result)
    [ [[5]]
    , [[1, 0, 0], [0, 1, 0], [0, 0, 1]]
    , [[0, 0, 1], [0, 1, 0], [1, 0, 0]]
    , [[4, 3], [2, 5]]
    , [[2, 5], [4, 3]]
    , [[4, 4], [2, 2]]
    ]
