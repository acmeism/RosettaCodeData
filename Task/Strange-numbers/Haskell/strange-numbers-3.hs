import Data.Array

task2a :: Int
task2a = sum $ elems $ iterate step arr0 !! 9
  where
    arr0 = listArray (0,9) (0:1:repeat 0)
    step arr = accumArray (+) 0 (0,9)
      [ (e,c)
      | (d,c) <- assocs arr
      , p <- [-7, -5, -3, -2, 2, 3, 5, 7]
      , let e = d + p, 0 <= e, e <= 9]
