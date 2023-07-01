primes = 2:3:[n | n <- [5,7..], foldr (\p r-> p*p > n || rem n p > 0 && r)
	True (drop 1 primes)]

merge aa@(a:as) bb@(b:bs)
	| a < b = a:merge as bb
	| otherwise = b:merge aa bs

-- n-th item is all k-primes not divisible by any of the first n primes
notdivs k = f primes $ kprimes (k-1) where
	f (p:ps) s = map (p*) s : f ps (filter ((/=0).(`mod`p)) s)

kprimes k
	| k == 1 = primes
	| otherwise = f (head ndk) (tail ndk) (tail $ map (^k) primes) where
		ndk = notdivs k
		-- tt is the thresholds for merging in next sequence
		-- it is equal to "map head seqs", but don't do that
		f aa@(a:as) seqs tt@(t:ts)
			| a < t = a : f as seqs tt
			| otherwise = f (merge aa $ head seqs) (tail seqs) ts

main = do
	-- next line is for task requirement:
	mapM_ (\x->print (x, take 10 $ kprimes x)) [1 .. 5]

	putStrLn "\n10000th to 10100th 500-amost primes:"
	mapM_ print $ take 100 $ drop 10000 $ kprimes 500
