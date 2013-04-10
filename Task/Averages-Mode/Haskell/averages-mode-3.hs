import Data.List (partition)

mode :: (Eq a) => [a] -> [a]
mode = snd . modesWithCount
    where modesWithCount :: (Eq a) => [a] -> (Int, [a])
          modesWithCount [] = (0,[])
          modesWithCount l@(x:_) | length xs > best = (length xs, [x])
                                 | length xs < best = (best, modes)
                                 | otherwise        = (best, x:modes)
            where (xs, notxs) = partition (== x) l
                  (best, modes) = modesWithCount notxs
