inorder n = and $ zipWith (<=) n (tail n) -- or use Data.List.Ordered

mk012 :: Int -> Int -> [Int]	-- definitely unordered
mk012 n = (++[0]).(2:).map (`mod` 3).take n.frr where
	-- frr = Fast Rubbish Randoms
	frr = tail . iterate (\n -> n * 7 + 13)

dutch1 n = (filter (==0) n)++(filter (==1) n)++(filter (==2) n)

dutch2 n = a++b++c where
	(a,b,c) = foldl f ([],[],[]) n -- scan list once; it *may* help
	f (a,b,c) x = case x of
		0 -> (0:a, b, c)
		1 -> (a, x:b, c)
		2 -> (a, b, x:c)

main = do -- 3 methods, comment/uncomment each for speed comparisons
--	print $ inorder $ sort s	-- O(n log n)
--	print $ inorder $ dutch1 s	-- O(n)
	print $ inorder $ dutch2 s	-- O(n)
	where s = mk012 10000000 42
