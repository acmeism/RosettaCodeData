perfectShuffle :: [a] -> [a]
perfectShuffle [] = []
perfectShuffle lst | odd n = b : shuffle (zip bs a)
                   | even n = shuffle (zip (b:bs) a)
  where
    n = length lst
    (a,b:bs) = splitAt (n `div` 2) lst
    shuffle = foldMap (\(x,y) -> [x,y])
	
shuffleP :: Eq a => [a] -> [a]
shuffleP lst = swapShuffle lst $ perfectShuffle lst
