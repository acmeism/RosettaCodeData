digSum base = f 0 where
	f a n = let (q,r) = n`divMod`base in
		if q == 0 then a+r else f (a+r) q

digRoot base = f 0 where
	f p n	| n < base = (p,n)
		| otherwise = f (p+1) (digSum base n)

main =	do
	putStrLn "in base 10:"
	mapM_ print $ map (\x -> (x, digRoot 10 x)) [627615, 39390, 588225, 393900588225]
