equilibriumIndices :: [Int] -> [Int]
equilibriumIndices xs =
  zip3
    (scanl1 (+) xs) -- Sums from the left
    (scanr1 (+) xs) -- Sums from the right
    [0 ..] -- Indices
    >>= (\(x, y, i) -> [i | x == y])

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    print
    $ equilibriumIndices
      <$> [ [-7, 1, 5, 2, -4, 3, 0],
            [2, 4, 6],
            [2, 9, 2],
            [1, -1, 1, -1, 1, -1, 1],
            [1],
            []
          ]
