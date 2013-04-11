import Data.List
import Control.Arrow
import Control.Monad

derangements [1] = [[1]]
derangements xs = filter (and . zipWith (/=) [1..] ). permutations $ xs
topswop = ((uncurry (++). first reverse).). splitAt
topswopIter = takeWhile((/=1).head). iterate (topswop =<< head)
swops =  map (length. topswopIter). derangements

topSwops :: [Int] -> [(Int, Int)]
topSwops = zip [1..]. map (maximum. swops). drop 1. inits
