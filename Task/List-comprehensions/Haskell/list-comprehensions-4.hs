pyth :: Int -> [(Int, Int, Int)]
pyth n =
  concatMap
    (\x ->
        concatMap
          (\y ->
              concatMap
                (\z ->
                    if x ^ 2 + y ^ 2 == z ^ 2
                      then [(x, y, z)]
                      else [])
                [y .. n])
          [x .. n])
    [1 .. n]

main :: IO ()
main = print $ pyth 25
