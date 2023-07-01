import Control.Monad (foldM)
import Data.List (partition)

binSplit :: Ord a => [a] -> [a] -> [[a]]
binSplit lims ns = counts ++ [rest]
  where
    (counts, rest) = foldM split ns lims
    split l i = let (a, b) = partition (< i) l in ([a], b)

binCounts :: Ord a => [a] -> [a] -> [Int]
binCounts b = fmap length . binSplit b
