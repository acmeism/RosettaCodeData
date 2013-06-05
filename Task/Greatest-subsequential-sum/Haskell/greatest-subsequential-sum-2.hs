maxsubseq = snd . foldl f ((0,[]),(0,[])) where
	f ((h1,h2),sofar) x = (a,b) where
		a = max (0,[]) (h1 + x, h2 ++ [x])
		b = max sofar a

main = print $ maxsubseq [-1, -2, 3, 5, 6, -2, -1, 4, -4, 2, -1]
