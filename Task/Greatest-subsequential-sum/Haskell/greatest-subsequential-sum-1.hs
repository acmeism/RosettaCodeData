import Data.List (inits, tails, maximumBy)
import Data.Ord (comparing)

subseqs :: [a] -> [[a]]
subseqs = concatMap inits . tails

maxsubseq :: (Ord a, Num a) => [a] -> [a]
maxsubseq = maximumBy (comparing sum) . subseqs

main = print $ maxsubseq [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
