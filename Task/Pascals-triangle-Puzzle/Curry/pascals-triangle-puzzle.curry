import CLPFD
import Constraint (allC, andC)
import Findall (findall)
import List (init, last)


solve :: [[Int]] -> Success
solve body@([n]:rest) =
    domain (concat body) 1 n
  & andC (zipWith atop body rest)
  & labeling [] (concat body)
  where
    xs `atop` ys = andC $ zipWith3 tri xs (init ys) (tail ys)

tri :: Int -> Int -> Int -> Success
tri x y z = x =# y +# z

test (x,y,z) | tri y x z =
    [ [151]
    , [ _,  _]
    , [40,  _, _]
    , [ _,  _, _, _]
    , [ x, 11, y, 4, z]
    ]
main = findall $ solve . test
