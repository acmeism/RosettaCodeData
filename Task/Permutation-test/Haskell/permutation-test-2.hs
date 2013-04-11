binomial n m = (f !! n) `div` (f !! m) `div` (f !! (n - m))
	where f = scanl (*) 1 [1..]

perms treat ctrl = (less,total) where
	total = binomial (length ctrl + length treat) (length treat)
	less = length	$ filter (<= sum treat)
			$ sums (treat ++ ctrl) (length treat)
	sums x n
		| l < n || n < 0 = []
		| n == 0 = [0]
		| l == n = [sum x]
		| otherwise = [a + b | i <- [0..n], a <- sums left i, b <- sums right (n - i)]
			where	(l, l1) = (length x, l `div` 2)
				(left, right) = splitAt l1 x

main = print $ (lt, 100 - lt) where
	(a, b) = perms	[85, 88, 75, 66, 25, 29, 83, 39, 97]
			[68, 41, 10, 49, 16, 65, 32, 92, 28, 98]
	lt = (fromIntegral a) / (fromIntegral b) * 100
