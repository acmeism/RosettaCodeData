powersOfTwo :: [Int]
powersOfTwo = iterate (2 *) 1

unrepresentable :: [Int]
unrepresentable = merge powersOfTwo ((5 *) <$> powersOfTwo)

merge :: [Int] -> [Int] -> [Int]
merge xxs@(x:xs) yys@(y:ys)
  | x < y = x : merge xs yys
  | otherwise = y : merge xxs ys

main :: IO ()
main = do
  putStrLn "The values of d <= 2200 which can't be represented."
  print $ takeWhile (<= 2200) unrepresentable
