import Data.Array

swap (x,y) = (y,x)

transpArray :: (Ix a, Ix b) => Array (a,b) e -> Array (b,a) e
transpArray a = ixmap (swap l, swap u) swap a where
  (l,u) = bounds a
