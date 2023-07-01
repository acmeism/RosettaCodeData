import Data.List (intersect)

------------------ SUM AND PRODUCT PUZZLE ----------------

s1, s2, s3, s4 :: [(Int, Int)]
s1 =
  [2 .. 100]
    >>= \x ->
      [succ x .. 100]
        >>= \y ->
          [ (x, y)
            | x + y < 100
          ]

s2 = filter (all ((1 /=) . length . mulEq) . sumEq) s1

s3 = filter ((1 ==) . length . (`intersect` s2) . mulEq) s2

s4 = filter ((1 ==) . length . (`intersect` s3) . sumEq) s3

sumEq, mulEq :: (Int, Int) -> [(Int, Int)]
sumEq p = filter ((add p ==) . add) s1
mulEq p = filter ((mul p ==) . mul) s1

add, mul :: (Int, Int) -> Int
add = uncurry (+)
mul = uncurry (*)

--------------------------- TEST -------------------------
main :: IO ()
main = print $ take 1 s4
