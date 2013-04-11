import Data.Array
import Data.Int (Int64)

q = qq [listArray (1,2) [1,1]] 1 where
	qq a n = seek aa n : qq aa (1 + n) where
		aa	| n <= l = a
			| otherwise = listArray (l+1,l*2) (take l $ drop 2 lst):a
			where
			l = snd (bounds $ head a)
			lst = seek a (l-1):seek a l:(ext lst (l+1))
			ext (q1:q2:qs) i = (g (i-q2) + g (i-q1)):ext (q2:qs) (1+i)
			g = seek aa
		seek (ar:ars) n
			| n >= fst (bounds ar) = ar ! n
			| otherwise = seek ars n

-- Only a perf test. Task can be done exactly the same as above
main = print $ sum qqq
	where	qqq :: [Int64]
		qqq = map fromIntegral $ take 3000000 q
