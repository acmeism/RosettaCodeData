import Data.List (sort)

r :: [Int]
r = scanl (+) 1 s

s :: [Int]
s = 2 : 4 : tail (complement (tail r))
  where
    complement = concat . interval
    interval x = zipWith (\x y -> [succ x .. pred y]) x (tail x)

main :: IO ()
main = do
  putStr "R: "
  print (take 10 r)
  putStr "S: "
  print (take 10 s)
  putStr "test 1000: "
  print $ [1 .. 1000] == sort (take 40 r ++ take 960 s)
