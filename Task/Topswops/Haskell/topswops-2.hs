import Data.List
import Control.Arrow
import Control.Monad

derangements = filter (and . zipWith (/=) [1..] ). permutations
topswop = ((uncurry (++). first reverse).). splitAt
topswopIter = takeWhile((/=1).head). iterate (topswop =<< head)
swops =  map (length. topswopIter). derangements

topSwops :: [Int] -> [(Int, Int)]
topSwops = zip [1..]. map (maximum. (0:). swops). tail. inits
