{-# LANGUAGE BangPatterns #-}

import Data.List (foldl') -- '
import Data.STRef
import Control.Monad.ST

data Pair a b = Pair !a !b

sumLen :: [Double] -> Pair Double Double
sumLen = fiof2 . foldl' (\(Pair s l) x -> Pair (s+x) (l+1)) (Pair 0.0 0) --'
  where fiof2 (Pair s l) = Pair s (fromIntegral l)

divl :: Pair Double Double -> Double
divl (Pair _ 0.0) = 0.0
divl (Pair s   l) = s / l

sd :: [Double] -> Double
sd xs = sqrt $ foldl' (\a x -> a+(x-m)^2) 0 xs / l --'
  where p@(Pair s l) = sumLen xs
        m = divl p

mkSD :: ST s (Double -> ST s Double)
mkSD = go <$> newSTRef []
  where go acc x =
          modifySTRef acc (x:) >> (sd <$> readSTRef acc)

main = mapM_ print $ runST $
  mkSD >>= forM [2.0, 4.0, 4.0, 4.0, 5.0, 5.0, 7.0, 9.0]
