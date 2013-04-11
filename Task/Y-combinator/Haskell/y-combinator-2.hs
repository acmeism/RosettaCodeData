fix :: (a -> a) -> a
fix f = f (fix f)

fac :: Integer -> Integer
fac' f n | n <= 0    = 1
         | otherwise = n * f (n-1)
fac = fix fac'

-- a simple but wasteful exponential time definition:
fib :: Integer -> Integer
fib' f 0 = 0
fib' f 1 = 1
fib' f n = f (n-1) + f (n-2)
fib = fix fib'

-- Or for far more efficiency, compute a lazy infinite list. This is
-- a Y-combinator version of: fibs = 0:1:zipWith (+) fibs (tail fibs)
fibs :: [Integer]
fibs' a = 0:1:(fix zipP a (tail a))
    where
      zipP f (x:xs) (y:ys) = x+y : f xs ys
fibs = fix fibs'

-- This code shows how the functions can be used:
main = do
  print $ map fac [1 .. 20]
  print $ map fib [0 .. 19]
  print $ take 20 fibs
