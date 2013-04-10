import Data.Array

binarySearchArray :: (Ix i, Integral i, Ord e) => Array i e -> e -> Maybe i
binarySearchArray a x = binarySearch p (bounds a) where
  p m = x `compare` (a ! m)
