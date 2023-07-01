import Data.List (inits, tails)

subseqs = foldr (\x s -> [x] : map (x:) s ++ s) []

consecs = concatMap (tail.inits) . tails

minus [] [] = []
minus (a:as) bb@(b:bs)
	| a == b = minus as bs
	| otherwise = a:minus as bb

disjoint s = (subseqs s) `minus` (consecs s)

main = mapM_ print $ disjoint [1..4]
