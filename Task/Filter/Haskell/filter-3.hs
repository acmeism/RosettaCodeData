import Data.Array

ary = listArray (1,10) [1..10]
evens = listArray (1,n) l where
  n = length l
  l = [x | x <- elems ary, even x]
