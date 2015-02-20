tail . concat
  . unfoldr (\(a:b:r)-> case span (< head b) a of (h,t)-> Just (h, minus t b:r))
  . scanl1 (zipWith(+) . tail) $ tails [1..]
