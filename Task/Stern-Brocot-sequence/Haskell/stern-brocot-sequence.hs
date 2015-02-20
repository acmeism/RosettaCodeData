import Data.List

sb = 1:1: f (tail sb) sb where
	f (a:aa) (b:bb) = a+b : a : f aa bb

main = do
	print $ take 15 sb
	print [(i,1 + (\(Just i)->i) (elemIndex i sb)) | i <- [1..10]++[100]]
	print $ all (\(a,b)->1 == gcd a b) $ take 1000 $ zip sb (tail sb)
