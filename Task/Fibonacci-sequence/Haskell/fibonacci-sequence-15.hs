import Data.List (unfoldr)

fibs :: [Integer]
fibs = unfoldr (\(x, y) -> Just (x, (y, x + y))) (0, 1)

fib n :: Integer -> Integer
fib n = fibs !! n
