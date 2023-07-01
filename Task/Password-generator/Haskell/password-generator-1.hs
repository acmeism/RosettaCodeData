import Control.Monad
import Control.Monad.Random
import Data.List

password :: MonadRandom m => [String] -> Int -> m String
password charSets n = do
  parts <- getPartition n
  chars <- zipWithM replicateM parts (uniform <$> charSets)
  shuffle (concat chars)
  where
    getPartition n = adjust <$> replicateM (k-1) (getRandomR (1, n `div` k))
    k = length charSets
    adjust p = (n - sum p) : p

shuffle :: (Eq a, MonadRandom m) => [a] -> m [a]
shuffle [] = pure []
shuffle lst = do
  x <- uniform lst
  xs <- shuffle (delete x lst)
  return (x : xs)
