import Data.Array (listArray, (!), bounds, elems)

step rule a = listArray (l,r) res
  where (l,r) = bounds a
        res = [rule (a!r)     (a!l) (a!(l+1)) ] ++
              [rule (a!(i-1)) (a!i) (a!(i+1)) | i <- [l+1..r-1] ] ++
              [rule (a!(r-1)) (a!r) (a!l)     ]

runCA rule = iterate (step rule)
