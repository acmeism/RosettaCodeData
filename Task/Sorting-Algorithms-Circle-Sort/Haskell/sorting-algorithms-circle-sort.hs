import Data.Bool (bool)

circleSort :: Ord a => [a] -> [a]
circleSort xs = if swapped then circleSort ks else ks
  where
    (swapped,ks) = go False xs (False,[])

    go d []  sks = sks
    go d [x] (s,ks) = (s,x:ks)
    go d xs  (s,ks) =
      let (st,_,ls,rs) = halve d s xs xs
      in go False ls (go True rs (st,ks))

    halve d s (y:ys) (_:_:zs) = swap d y (halve d s ys zs)
    halve d s ys     []       = (s,ys,[],[])
    halve d s (y:ys) [_]      = (s,ys,[y | e],[y | not e])
      where e = y <= head ys

    swap d x (s,y:ys,ls,rs)
      | bool (<=) (<) d x y = (    d || s,ys,x:ls,y:rs)
      | otherwise           = (not d || s,ys,y:ls,x:rs)
