{-# LANGUAGE PostfixOperators #-}

(!) :: Integer -> Integer
(!) 0 = 1
(!) n = n * (pred n !)

main :: IO ()
main = do
  print (5 !)
  print ((4 !) !)
