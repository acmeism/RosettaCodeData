import Data.Array

choose :: Integer -> Int -> Integer
choose m k = let kk = toInteger k in (product [m..m+kk-1]) `div` (product [1..kk])

max_branches = 4
max_nodes = 200

bcache = listArray (0, max_nodes)
	[sum[rcache!n!b!r | r <- [0..n], b <- [0..max_branches-1]] | n <- [0..max_nodes]]
build_block = (bcache !)

rcache = listArray (0,max_nodes) [arr_b i | i <- [0..max_nodes]] where
	arr_b n = listArray(0,max_branches) [arr_r b n | b <- [0..max_branches]]
	arr_r b n = listArray(0,n) [rooted n b r | r <- [0..n]]

rooted 1 0 0 = 1
rooted 1 _ _ = 0
rooted _ 0 _ = 0
rooted _ _ 0 = 0
rooted n b r
	| (n <= b) || (n <= r) = 0
	| otherwise = sum [(firsts b1) * (rests b1) | b1 <- [1..b], r * b1 < n] where
		firsts = choose (build_block r)
		rests bb = sum [rcache!(n-r*bb)!(b - bb)!r1 | r1 <- [0..r-1], r1 < (n-r*bb)]

unrooted n = unicenter + bycenter where
	unicenter = sum [ rcache!n!b!r | b <- [0..max_branches], r <-[0..n], r * 2 < n]
	bycenter| odd n = 0
		| otherwise = x * (x + 1) `div` 2 where x = build_block (n `div` 2)

main = mapM_ print $ map (\x->(x, unrooted x)) [1..max_nodes]
