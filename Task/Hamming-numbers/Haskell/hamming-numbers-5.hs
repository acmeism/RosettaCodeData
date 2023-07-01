hamm = foldr merge1 [] . iterate (map (5*)) .
         foldr merge1 [] . iterate (map (3*))
                                $ iterate (2*) 1
    where
    merge1 (x:xs) ys = x : merge xs ys

{- 1,  2,  4,  8,  16,  32, ...
   3,  6, 12, 24,  48,  96, ...
   9, 18, 36, 72, 144, 288, ...
   27, ... -}
