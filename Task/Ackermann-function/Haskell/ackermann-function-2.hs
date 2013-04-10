-- everything here are [Int] or [[Int]], which would overflow
-- * had it not overrun the stack first *
ackermann = iterate ack [1..] where
	ack a = s where
		s = a!!1 : f (tail a) (zipWith (-) s (1:s))
	f a (b:bs) = (head aa) : f aa bs where
		aa = drop b a

main = mapM_ print $ map (\n -> take (6 - n) $ ackermann !! n) [0..5]
