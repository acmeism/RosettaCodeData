import Data.List (unfoldr)

digSum base = sum . unfoldr f where
        f 0 = Nothing
	f n = Just (r,q) where (q,r) = n `divMod` base

digRoot base = head . dropWhile ((>= base).snd) . zip [0..] . iterate (digSum base)

main =	do
	putStrLn "in base 10:"
	mapM_ print $ map (\x -> (x, digRoot 10 x)) [627615, 39390, 588225, 393900588225]
