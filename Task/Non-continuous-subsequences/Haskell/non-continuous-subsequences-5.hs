import Data.List (inits, tails)

subseqs [] = []
subseqs (x:xs) = [x] : map (x:) s ++ s where s = subseqs xs

consecs x = concatMap (tail.inits) (tails x)

minus [] [] = []
minus (a:as) bb@(b:bs)
	| a == b = minus as bs
	| otherwise = a:minus as bb

disjoint s = (subseqs s) `minus` (consecs s)

main = mapM_ print $ disjoint [1..4]
