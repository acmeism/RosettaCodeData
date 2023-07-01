randomShuffle :: [a] -> IO [a]
randomShuffle [] = return []
randomShuffle lst = do
  i <- getRandomR (0,length lst-1)
  let (a, x:b) = splitAt i lst
  xs <- randomShuffle $ a ++ b
  return (x:xs)

shuffleR :: Eq a => [a] -> IO [a]
shuffleR lst = swapShuffle lst <$> randomShuffle lst
