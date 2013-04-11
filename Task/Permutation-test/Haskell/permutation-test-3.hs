combs maxsum len x = foldl f [(0,0,1)] x where
	f a n = merge a (map (addNum n) $ filter (\(l,_,_) -> l < len) a)
	addNum n (a,s,c)
		-- anything larger than maxsum is as good as infinity
		| s + n > maxsum = (a+1, maxsum + 1, c)
		| otherwise = (a+1, s+n, c)

	merge a [] = a
	merge [] a = a
	merge a@((a1,a2,a3):as) b@((b1,b2,b3):bs)
		| a1 == b1 && a2 == b2 = (a1,a2,a3+b3):merge as bs
		| a1 < b1 || (a1 == b1 && a2 < b2) = (a1,a2,a3):merge as b
		| otherwise = (b1,b2,b3):merge a bs

permtest a b = (lt, ge) where
	lt = sum	$ map (\(a,b,c) -> if a == la && b < sa then c else 0)
			$ combs sa la (a++b)
	ge = (binomial (la + lb) la) - lt
	(sa, la, lb) = (sum a, length a, length b)

binomial n m = (f !! n) `div` (f !! m) `div` (f !! (n - m))
	where f = scanl (*) 1 [1..]

-- how many combinations are less than current sum
main =	print$ permtest	[85, 88, 75, 66, 25, 29, 83, 39, 97]
			[68, 41, 10, 49, 16, 65, 32, 92, 28, 98]
