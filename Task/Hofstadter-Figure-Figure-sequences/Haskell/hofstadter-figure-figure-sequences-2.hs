import Data.List (sort)

r = scanl (+) 1 s
s = 2:4:tail (compliment (tail r)) where
	compliment = concat.interval
	interval x = zipWith (\x y -> [x+1..y-1]) x (tail x)

main = do
	putStr "R: "; print (take 10 r)
	putStr "S: "; print (take 10 s)
	putStr "test 1000: ";
	print ([1..1000] == sort ((take 40 r) ++ (take 960 s)))
