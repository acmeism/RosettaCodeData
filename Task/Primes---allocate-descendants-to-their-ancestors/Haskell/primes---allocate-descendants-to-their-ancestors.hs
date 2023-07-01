{-# LANGUAGE DeriveFunctor #-}
import Data.Numbers.Primes (isPrime)
import Data.List

------------------------------------------------------------
-- memoization utilities

type Memo2 a = Memo (Memo a)

data Memo a = Node a (Memo a) (Memo a)
  deriving Functor

memo :: Integral a => Memo p -> a -> p
memo (Node a l r) n
  | n == 0 = a
  | odd n = memo l (n `div` 2)
  | otherwise = memo r (n `div` 2 - 1)

nats :: Integral a => Memo a
nats = Node 0 ((+1).(*2) <$> nats) ((*2).(+1) <$> nats)

memoize :: Integral a => (a -> b) -> (a -> b)
memoize f = memo (f <$> nats)

memoize2 :: (Integral a, Integral b) => (a -> b -> c) -> (a -> b -> c)
memoize2 f = memoize (memoize . f)

------------------------------------------------------------

partProd = memoize2 partProdM
  where
    partProdM x p
      | p == 0 = []
      | x == 0 = [1]
      | x < 0 = []
      | isPrime p = ((p *) <$> partProdM (x - p) p) ++
                    partProd x (p - 1)
      | otherwise = partProd x (p - 1)

descendants = memoize descendantsM
  where
    descendantsM x =
      if x == 4 then [] else sort (partProd x (x - 1))

ancestors = memoize ancestorsM
  where
    ancestorsM z = concat [ ancestors x ++ [x]
                          | x <- [z-1,z-2..1]
                          , z `elem` descendants x ]

main = do
  mapM_ (putStrLn . task1) [1..15]
  putStrLn (task2 46)
  putStrLn (task2 99)
  putStrLn task3
  where
    task1 n = show n ++
              "  ancestors:" ++ show (ancestors n) ++
              "  descendants:" ++ show (descendants n)
    task2 n = show n ++ " has " ++
              show (length (ancestors n)) ++ " ancestors, " ++
              show (length (descendants n)) ++ " descendants."
    task3 = "Total ancestors up to 99: " ++
            show (sum $ length . ancestors <$> [1..99]) ++
            "\nTotal descendants up to 99: " ++
            show (sum $ length . descendants <$> [1..99])
