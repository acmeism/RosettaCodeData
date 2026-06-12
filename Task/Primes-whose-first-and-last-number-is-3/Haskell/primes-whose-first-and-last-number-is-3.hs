isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

condition :: Int -> Bool
condition n = isPrime n && head numstr == '3' && last numstr == '3'
 where
  numstr :: String
  numstr = show n

solution :: [Int]
solution = filter condition [1..3999]

main :: IO ( )
main = do
   print solution
   putStrLn ( "There are " ++ ( show $ length $ filter condition [1..999999]
            ) ++ " 3 x 3 primes below 1000000!" )
