{-# LANGUAGE PostfixOperators #-}

(!) 0 = 1
(!) n = n * ((n-1)!)

main = do
  print (5!)
  print ((4!)!)
