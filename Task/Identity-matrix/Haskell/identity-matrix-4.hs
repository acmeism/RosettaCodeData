idMatrix :: Int -> [[Int]]
idMatrix n =
  let xs = [1 .. n]
  in xs >>= \x -> [xs >>= \y -> [fromEnum (x == y)]]
