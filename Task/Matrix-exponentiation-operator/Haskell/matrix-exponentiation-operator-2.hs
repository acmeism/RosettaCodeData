import Numeric.LinearAlgebra

a :: Matrix I
a = (2><2)
  [1,2
  ,0,1]

main = do
  print $ a^4
  putStrLn "power of zero: "
  print $ a^0
