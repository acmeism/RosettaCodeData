import Data.List (sort)

inorder n = and $ zipWith (<=) n (tail n) -- or use Data.List.Ordered

mk012 :: Int -> Int -> [Int]	-- definitely unordered
mk012 n = (++[0]).(2:).map (`mod` 3).take n.frr where
	-- frr = Fast Rubbish Randoms
	frr n = r:frr r where r = n * 7 + 13

dutch1 n = (filter (==0) n)++(filter (==1) n)++(filter (==2) n)

dutch2 n = tric [] [] [] n where -- scan list once; it *may* help
	tric a b c [] = a++b++c
	tric a b c (x:xs) = case x of
		0 -> tric (x:a) b c xs
		1 -> tric a (x:b) c xs
		2 -> tric a b (x:c) xs

main = do -- 3 methods, comment/uncomment each for speed comparisons
--	print $ inorder $ sort s	-- O(n log n)
--	print $ inorder $ dutch1 s	-- O(n)
	print $ inorder $ dutch2 s	-- O(n)
	where s = mk012 10000000 42
