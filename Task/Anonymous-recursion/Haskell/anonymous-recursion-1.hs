fib :: Integer -> Maybe Integer
fib n
  | n < 0 = Nothing
  | otherwise = Just $ real n
              where real 0 = 1
                    real 1 = 1
                    real n = real (n-1) + real (n-2)
