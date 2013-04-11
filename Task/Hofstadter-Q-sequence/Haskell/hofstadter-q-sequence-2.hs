import Data.Array

qSequence n = arr
  where
     arr = listArray (1,n) $ 1:1: map g [3..n]
     g i = arr!(i - arr!(i-1)) +
           arr!(i - arr!(i-2))

gradualth m k arr                         -- gradually precalculate m-th item
        | m <= v = pre `seq` arr!m        --   in steps of k
  where                                   --     to prevent STACK OVERFLOW
    pre = foldl1 (\a b-> a `seq` arr!b) [u,u+k..m]
    (u,v) = bounds arr

qSeqTest m n = let arr = qSequence $ max m n in
  ( take 10 . elems  $ arr                       -- 10 first items
  , gradualth m 10000 $ arr                      -- m-th item
  , length . filter (> 0)                       -- reversals in n items
     . _S (zipWith (-)) tail . take n . elems $ arr )

_S f g x = f x (g x)
