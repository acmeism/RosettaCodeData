import Data.Complex ( Complex((:+)) )

main :: IO ()
main = mapM_ print [
     0 ^ 0,
     0.0 ^ 0,
     0 ^^ 0,
     0 ** 0,
    (0 :+ 0) ^ 0,
    (0 :+ 0) ** (0 :+ 0)
  ]
