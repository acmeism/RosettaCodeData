root :: Integer -> Integer -> Integer
root a b = findAns $ iterate (\x -> (a1 * x + b `div` (x ^ a1)) `div` a) 1
  where
    a1 = a - 1
    findAns (x:xs@(y:z:_))
      | x == y || x == z = min y z
      | otherwise = findAns xs

main :: IO ()
main = do
  print $ root 3 8
  print $ root 3 9
  print $ root 2 (2 * 100 ^ 2000) -- first 2001 digits of the square root of 2
