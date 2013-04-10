import Data.Function (fix)

fib :: Integer -> Maybe Integer
fib n
  | n < 0 = Nothing
  | otherwise = Just $ fix (\f -> (\n -> if n > 1 then f (n-1) + f (n-2) else 1)) n
