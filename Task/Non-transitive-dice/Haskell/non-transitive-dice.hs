{-# language LambdaCase #-}
import Data.List
import Control.Monad

newtype Dice = Dice [Int]

instance Show Dice where
  show (Dice s) = "(" ++ unwords (show <$> s) ++ ")"

instance Eq Dice where
  d1 == d2 = d1 `compare` d2 == EQ

instance Ord Dice where
  Dice d1 `compare` Dice d2 = (add $ compare <$> d1 <*> d2) `compare` 0
    where
      add = sum . map (\case {LT -> -1; EQ -> 0; GT -> 1})

dices n = Dice <$> (nub $ sort <$> replicateM n [1..n])

nonTrans dice = filter (\x -> last x < head x) . go
  where
    go 0 = []
    go 1 = sequence [dice]
    go n = do
      (a:as) <- go (n-1)
      b <- filter (< a) dice
      return (b:a:as)
