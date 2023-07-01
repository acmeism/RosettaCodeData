import Data.List (sortBy)
import Data.Ord (comparing)
import Data.Ratio ((%))

nines = iterate ((+9).(*10)) 9

maxcat = foldl (\a (n,d)->a * (1 + d) + n) 0 .
    sortBy (flip $ comparing $ uncurry (%)) .
    map (\a->(a, head $ dropWhile (<a) nines))

main = mapM_ (print.maxcat) [[1,34,3,98,9,76,45,4], [54,546,548,60]]
