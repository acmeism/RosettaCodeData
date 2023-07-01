import Numeric.LinearAlgebra

a :: Matrix I
a = (3><2)
  [1,2
  ,3,4
  ,5,6]

main = do
  print $ a
  print $ tr a
