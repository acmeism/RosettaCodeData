import Data.List (mapAccumL)

-- everything here are [Int] or [[Int]], which would overflow
-- * had it not overrun the stack first *
ackermann = iterate ack [1..] where
	ack a = s where
		s = snd $ mapAccumL f (tail a) (1 : zipWith (-) s (1:s))
	f a b = (aa, head aa) where aa = drop b a

main = mapM_ print $ map (\n -> take (6 - n) $ ackermann !! n) [0..5]
