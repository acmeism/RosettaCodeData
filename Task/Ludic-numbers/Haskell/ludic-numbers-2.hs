ludic = 1:2 : f 3 [3..] [(4,2)] where
	f n (x:xs) yy@((i,y):ys)
		| n == i = f n (dropEvery y xs) ys
		| otherwise = x : f (1+n) xs (yy ++ [(n+x, x)])

dropEvery n s = a ++ dropEvery n (tail b) where
	(a,b) = splitAt (n-1) s

main = print $ ludic !! 10000
