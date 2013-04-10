{-# LANGUAGE BangPatterns #-}
import Data.List (foldl')
mean :: (Real n, Fractional m) => [n] -> m
mean xs = let (s,l) = foldl' f (0, 0) xs in realToFrac s / l
  where f (!s,!l) x = (s+x,l+1)
