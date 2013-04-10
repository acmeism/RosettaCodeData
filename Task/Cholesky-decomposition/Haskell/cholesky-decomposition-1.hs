module Cholesky (Arr, cholesky) where

import Data.Array.IArray
import Data.Array.MArray
import Data.Array.Unboxed
import Data.Array.ST

type Idx = (Int,Int)
type Arr = UArray Idx Double

-- Return the (i,j) element of the lower triangular matrix.  (We assume the
-- lower array bound is (0,0).)
get :: Arr -> Arr -> Idx -> Double
get a l (i,j) | i == j = sqrt $ a!(j,j) - dot
              | i  > j = (a!(i,j) - dot) / l!(j,j)
              | otherwise = 0
  where dot = sum [l!(i,k) * l!(j,k) | k <- [0..j-1]]

-- Return the lower triangular matrix of a Cholesky decomposition.  We assume
-- the input is a real, symmetric, positive-definite matrix, with lower array
-- bounds of (0,0).
cholesky :: Arr -> Arr
cholesky a = let n = maxBnd a
             in runSTUArray $ do
               l <- thaw a
               mapM_ (update a l) [(i,j) | i <- [0..n], j <- [0..n]]
               return l
  where maxBnd = fst . snd . bounds
        update a l i = unsafeFreeze l >>= \l' -> writeArray l i (get a l' i)
