-- choose m out of n items, return tuple of chosen and the rest
choose aa _ 0 = [([], aa)]
choose aa@(a:as) n m
	| n == m = [(aa, [])]
	| otherwise =	map (\(x,y) -> (a:x, y)) (choose as (n-1) (m-1)) ++
			map (\(x,y) -> (x, a:y)) (choose as (n-1) m)

partitions x = combos [1..n] n x where
	n = sum x
	combos _ _ [] = [[]]
	combos s n (x:xs) = [ l : r |	(l,rest) <- choose s n x,
					r <- combos rest (n - x) xs]


main = mapM_ print $ partitions [5,5,5]
