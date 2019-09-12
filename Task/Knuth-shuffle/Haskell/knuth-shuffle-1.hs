import System.Random (randomRIO)

mkRands :: Int -> IO [Int]
mkRands = mapM (randomRIO . (,) 0) . enumFromTo 1 . pred

replaceAt :: Int -> a -> [a] -> [a]
replaceAt i c l =
  let (a, b) = splitAt i l
  in a ++ c : drop 1 b

swapElems :: (Int, Int) -> [a] -> [a]
swapElems (i, j) xs
  | i == j = xs
  | otherwise = replaceAt j (xs !! i) $ replaceAt i (xs !! j) xs

knuthShuffle :: [a] -> IO [a]
knuthShuffle xs = (foldr swapElems xs . zip [1 ..]) <$> mkRands (length xs)
