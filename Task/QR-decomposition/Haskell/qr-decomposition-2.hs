import Numeric.LinearAlgebra

a :: Matrix R
a = (3><3)
  [ 12, -51,   4
  ,  6, 167, -68
  , -4,  24, -41]

main = do
  print $ qr a
