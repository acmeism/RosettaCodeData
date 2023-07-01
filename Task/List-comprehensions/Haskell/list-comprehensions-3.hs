pyth :: Int -> [(Int, Int, Int)]
pyth n =
  [1 .. n] >>=
  \x ->
     [x .. n] >>=
     \y ->
        [y .. n] >>=
        \z ->
           case x ^ 2 + y ^ 2 == z ^ 2 of
             True -> [(x, y, z)]
             _ -> []
