randomLatinSquare :: Eq a => [a] -> Random [[a]]
randomLatinSquare set = do
  r <- randomPermutation set
  c <- randomPermutation (tail r)
  return $ latinSquare r (head r:c)
