import Data.List (maximumBy)
import Data.Ord (comparing)

maxDeltas :: (Num a, Ord a) => [a] -> [(a, (a, a))]
maxDeltas xs = filter ((delta ==) . fst) pairs
  where
    pairs =
      zipWith
        (\a b -> (abs (a - b), (a, b)))
        xs
        (tail xs)
    delta = fst $ maximumBy (comparing fst) pairs

main :: IO ()
main =
  mapM_ print $
    maxDeltas [1, 8, 2, -3, 0, 1, 1, -2.3, 0, 5.5, 8, 6, 2, 9, 11, 10, 3]
