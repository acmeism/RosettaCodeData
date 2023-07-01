import Control.Monad.ST
import Control.Monad
import Data.Array.ST
import Data.List
import qualified Data.Set as S

newtype Pile a = Pile [a]

instance Eq a => Eq (Pile a) where
  Pile (x:_) == Pile (y:_) = x == y

instance Ord a => Ord (Pile a) where
  Pile (x:_) `compare` Pile (y:_) = x `compare` y

patienceSort :: Ord a => [a] -> [a]
patienceSort = mergePiles . sortIntoPiles where

  sortIntoPiles :: Ord a => [a] -> [[a]]
  sortIntoPiles lst = runST $ do
      piles <- newSTArray (1, length lst) []
      let bsearchPiles x len = aux 1 len where
            aux lo hi | lo > hi = return lo
                      | otherwise = do
              let mid = (lo + hi) `div` 2
              m <- readArray piles mid
              if head m < x then
                aux (mid+1) hi
              else
                aux lo (mid-1)
          f len x = do
            i <- bsearchPiles x len
            writeArray piles i . (x:) =<< readArray piles i
            return $ if i == len+1 then len+1 else len
      len <- foldM f 0 lst
      e <- getElems piles
      return $ take len e
      where newSTArray :: Ix i => (i,i) -> e -> ST s (STArray s i e)
            newSTArray = newArray

  mergePiles :: Ord a => [[a]] -> [a]
  mergePiles = unfoldr f . S.fromList . map Pile where
    f pq = case S.minView pq of
             Nothing -> Nothing
             Just (Pile [x], pq') -> Just (x, pq')
             Just (Pile (x:xs), pq') -> Just (x, S.insert (Pile xs) pq')

main :: IO ()
main = print $ patienceSort [4, 65, 2, -31, 0, 99, 83, 782, 1]
