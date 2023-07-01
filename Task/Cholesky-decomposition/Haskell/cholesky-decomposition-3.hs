import Numeric.LinearAlgebra

a,b :: Matrix R
a = (3><3)
  [25, 15, -5
  ,15, 18, 0
  ,-5,  0, 11]

b = (4><4)
  [ 18, 22, 54, 42
  , 22, 70, 86, 62
  , 54, 86,174,134
  , 42, 62,134,106]

main = do
  let sa = sym a
      sb = sym b
  print sa
  print $ chol sa
  print sb
  print $ chol sb
  print $ tr $ chol sb
