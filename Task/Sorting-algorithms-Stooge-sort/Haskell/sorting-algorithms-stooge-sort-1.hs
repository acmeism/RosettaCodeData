import Data.List
import Control.Arrow
import Control.Monad

insertAt e k = uncurry(++).second ((e:).drop 1). splitAt k

swapElems :: [a] -> Int -> Int -> [a]
swapElems xs i j = insertAt (xs!!j) i $ insertAt (xs!!i) j xs
	
stoogeSort [] = []
stoogeSort [x] = [x]
stoogeSort xs = doss 0 (length xs - 1) xs
doss :: (Ord a) => Int -> Int -> [a] -> [a]
doss i j xs
      | j-i>1 = doss i (j-t) $ doss (i+t) j $ doss i (j-t) xs'
      | otherwise = xs'
    where t = (j-i+1)`div`3
	  xs'
	    | xs!!j < xs!!i = swapElems xs i j
	    | otherwise = xs
