fact n = foldr (*) 1 [1..n]

-- always assume elements are unique
rankPerm [] _ = []
rankPerm list n = c:rankPerm (a++b) r where
	(q,r) = n `divMod` fact (length list - 1)
	(a,c:b) = splitAt q list

permRank [] = 0
permRank (x:xs) = length(filter (<x) xs) * fact (length xs) + permRank xs

main = mapM_ f [0..23] where
	f n = print (n, p, permRank p) where
		p = rankPerm [0..3] n
