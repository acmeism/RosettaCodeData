permutationsSomeIdentical :: [(a, Int)] -> [[a]]
permutationsSomeIdentical [] = [[]]
permutationsSomeIdentical xs =
  [ x : ys
    | (x, xs_) <- select xs,
      ys <- permutationsSomeIdentical xs_
  ]
  where
    select [] = []
    select ((x, n) : xs) =
      (x, xs_) :
        [ (y, (x, n) : cs)
          | (y, cs) <- select xs
        ]
      where
        xs_
          | 1 == n = xs
          | otherwise = (x, pred n) : xs


main :: IO ()
main = do
  print $ permutationsSomeIdentical [(1, 2), (2, 1)]
  print $ permutationsSomeIdentical [(1, 2), (2, 3), (3, 1)]
  print $ permutationsSomeIdentical [('A', 2), ('B', 3), ('C', 1)]
