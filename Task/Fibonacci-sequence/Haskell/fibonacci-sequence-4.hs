import Data.MemoTrie
fib :: Integer -> Integer
fib = memo f where
   f 0 = 0
   f 1 = 1
   f n = fib (n-1) + fib (n-2)
