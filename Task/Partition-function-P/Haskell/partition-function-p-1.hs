{-# LANGUAGE DeriveFunctor #-}

------------------------------------------------------------
-- memoization utilities

data Memo a = Node a (Memo a) (Memo a)
  deriving (Functor)

memo :: Integral a => Memo p -> a -> p
memo (Node a l r) n
  | n == 0 = a
  | odd n = memo l (n `div` 2)
  | otherwise = memo r (n `div` 2 - 1)

nats :: Memo Int
nats =
  Node
    0
    ((+ 1) . (* 2) <$> nats)
    ((* 2) . (+ 1) <$> nats)

------------------------------------------------------------
-- calculating partitions

partitions :: Memo Integer
partitions = partitionP <$> nats

partitionP :: Int -> Integer
partitionP n
  | n < 2 = 1
  | otherwise = sum $ zipWith (*) signs terms
  where
    terms =
      [ memo partitions (n - i)
        | i <- takeWhile (<= n) ofsets
      ]
    signs = cycle [1, 1, -1, -1]

ofsets :: [Int]
ofsets = scanl1 (+) $ mix [1, 3 ..] [1, 2 ..]
  where
    mix a b = concat $ zipWith (\x y -> [x, y]) a b

main :: IO ()
main = print $ partitionP 6666
