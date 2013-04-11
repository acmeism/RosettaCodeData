fib = 1 : 2 : zipWith (+) fib (tail fib)

zeckendorf 0 = "0"
zeckendorf n = f n (reverse $ takeWhile (<=n) fib) where
	f _ [] = ""
	f n (x:xs)
		| n < x = '0' : f n xs
		| True  = '1' : f (n - x) xs

main = mapM (putStrLn . zeckendorf) [0..20]
