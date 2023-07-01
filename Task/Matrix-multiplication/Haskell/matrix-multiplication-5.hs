import Numeric.LinearAlgebra

a, b :: Matrix I
a = (2 >< 2) [1, 2, 3, 4]

b = (2 >< 3) [-3, -8, 3, -2, 1, 4]

main :: IO ()
main = print $ a <> b
