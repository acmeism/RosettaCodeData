maxsubseq = mss_ (0,[]) (0,[]) where
	mss_ _ x [] = x
	mss_ here sofar (x:xs) = mss a b xs where
		a = max (0,[]) (fst here + x, snd here ++ [x])
		b = max sofar a

main = print $ maxsubseq [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
