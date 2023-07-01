import Numeric.LinearAlgebra

a1, a2 :: Matrix R
a1 = (3><3)
  [1,3,5
  ,2,4,7
  ,1,1,0]

a2 = (4><4)
  [11,  9, 24,  2
  , 1,  5,  2,  6
  , 3, 17, 18,  1
  , 2,  5,  7,  1]

main = do
  print $ lu a1
  print $ lu a2
