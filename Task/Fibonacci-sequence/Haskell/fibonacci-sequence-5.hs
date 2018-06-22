import Data.MemoTrie
fib :: Integer -> Integer
fib = memo $ \x -> case x of
   0 -> 0
   1 -> 1
   n -> fib (n-1) + fib (n-2)
