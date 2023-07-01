import Data.List (unfoldr, intercalate)

newtype Fact = Fact [Int]

-- smart constructor
fact :: [Int] -> Fact
fact = Fact . zipWith min [0..] . reverse

instance Show Fact where
  show (Fact ds) = intercalate "." $ show <$> reverse ds

toFact :: Integer -> Fact
toFact 0 = Fact [0]
toFact n = Fact $ unfoldr f (1, n)
  where
    f (b, 0) = Nothing
    f (b, n) = let (q, r) = n `divMod` b
               in Just (fromIntegral r, (b+1, q))

fromFact :: Fact -> Integer
fromFact (Fact ds) = foldr f 0 $ zip [1..] ds
  where
    f (b, d) r = r * b + fromIntegral d
