gen :: Int -- number of needed digits
    -> Int -- least significant digit of v
    -> Int -- v : intermediate result
    -> [Int] -- rest : other results
    -> [Int]
gen 0 _ v rest = v : rest
gen k d v rest = foldr ($) rest
  [ gen (pred k) e (v * 10 + e)
  | p <- [-7, -5, -3, -2, 2, 3, 5, 7]
  , let e = d + p, 0 <= e, e <= 9]

task1 :: [Int]
task1 = foldr (\i -> gen 2 i i) [] [1 .. 4]

task2 = length $ gen 9 1 1 []
