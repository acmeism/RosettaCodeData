times :: (Monoid p, Integral a) => a -> p -> p
0 `times` _ = mempty
n `times` x = res
  where
    (res:_, _, _) = foldl f ([x], 1, 0) $ tail ch
    ch = reverse $ dichotomicChain n
    f (p:ps, c1, i) c2 = let Just j = elemIndex (c2-c1) ch
                         in ((p <> ((p:ps) !! (i-j))):p:ps, c2, i+1)
