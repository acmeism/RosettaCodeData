import Data.List (subsequences, tails, delete)

disjoint a = concatMap (cutAt a) [1..length a - 2] where
	cutAt s n = [a ++ b |	b <- delete [] (subsequences right),
				a <- init (tails left) ] where
		(left, _:right) = splitAt n s

main = print $ length $ disjoint [1..20]
