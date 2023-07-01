-- break n down into sum of smaller integers
parts :: Int -> [[(Int, Int)]]
parts n = f n 1
  where
    f n x
      | n == 0 = [[]]
      | x > n = []
      | otherwise =
        f n (x + 1) ++
        concatMap
          (\c -> map ((c, x) :) (f (n - c * x) (x + 1)))
          [1 .. n `div` x]

-- choose n strings out of a list and join them
pick :: Int -> [String] -> [String]
pick _ [] = []
pick 0 _ = [""]
pick n aa@(a:as) = map (a ++) (pick (n - 1) aa) ++ pick n as

-- pick parts to build a series of subtrees that add up to n-1,
-- then wrap them up
trees :: Int -> [String]
trees n =
  map (\x -> "(" ++ x ++ ")") $
  concatMap (foldr (prod . build) [""]) (parts (n - 1))
  where
    build (c, x) = pick c $ trees x
    prod aa bb =
      [ a ++ b
      | a <- aa
      , b <- bb ]

main :: IO ()
main = mapM_ putStrLn $ trees 5
