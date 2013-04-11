hamming = 1:foldl u [] [5,3,2] where
	u s n = ar where
		ar = merge s (n:map (n*) ar)
		merge [] b = b
		merge a@(x:xs) b@(y:ys)
			| x < y     = x:merge xs b
			| otherwise = y:merge a ys

main = do
	print $ take 20 hamming
	print $ hamming !! 1690
	print $ hamming !! (1000000-1)
