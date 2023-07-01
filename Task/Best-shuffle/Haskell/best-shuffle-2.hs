import Data.Vector ((//), (!))
import qualified Data.Vector as V
import Data.List (delete, find)

swapShuffle :: Eq a => [a] -> [a] -> [a]
swapShuffle lref lst = V.toList $ foldr adjust (V.fromList lst) [0..n-1]
  where
    vref = V.fromList lref
    n = V.length vref
    adjust i v = case find alternative [0.. n-1] of
      Nothing -> v
      Just j -> v // [(j, v!i), (i, v!j)]
      where
        alternative j = and [ v!i == vref!i
                            , i /= j
                            , v!i /= vref!j
                            , v!j /= vref!i ]

shuffle :: Eq a => [a] -> [a]
shuffle lst = swapShuffle lst lst
