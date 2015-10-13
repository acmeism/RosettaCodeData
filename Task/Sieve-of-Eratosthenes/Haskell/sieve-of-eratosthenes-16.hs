unfoldr (\(a:b:t) -> Just . (head &&& (:t) . (`minus` b)
                                           . tail) $ a)
     . scanl1 (zipWith (+)) $ repeat [2..]
