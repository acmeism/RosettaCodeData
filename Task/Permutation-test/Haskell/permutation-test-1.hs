binomial n m = (f !! n) `div` (f !! m) `div` (f !! (n - m))
	where f = scanl (*) 1 [1..]

permtest treat ctrl = (fromIntegral less) / (fromIntegral total) * 100
	where
	total = binomial (length avail) (length treat)
	less  = combos (sum treat) (length treat) avail
	avail = ctrl ++ treat
	combos total n a@(x:xs)
		| total < 0	= binomial (length a) n
		| n == 0	= 0
		| n > length a	= 0
		| n == length a = fromEnum (total < sum a)
		| otherwise	= combos (total - x) (n - 1) xs
				+ combos total n xs

main =	let	r = permtest
			[85, 88, 75, 66, 25, 29, 83, 39, 97]
			[68, 41, 10, 49, 16, 65, 32, 92, 28, 98]
	in do	putStr "> : "; print r
		putStr "<=: "; print $ 100 - r
