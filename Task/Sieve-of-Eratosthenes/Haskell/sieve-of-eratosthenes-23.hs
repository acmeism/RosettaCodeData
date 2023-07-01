tail . concat
     . unfoldr (\(a:b:t) -> Just . second ((:t) . (`minus` b))
                                 . span (< head b) $ a)
     . scanl1 (zipWith (+) . tail) $ tails [1..]
  -- $ [ [n*n, n*n+n..] | n <- [1..] ]
