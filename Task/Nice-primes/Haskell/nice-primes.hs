import Data.Char ( digitToInt )

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

digitsum :: Int -> Int
digitsum n = sum $ map digitToInt $ show n

findSumn :: Int -> Int
findSumn n = until ( (== 1) . length . show ) digitsum n

isNicePrime :: Int -> Bool
isNicePrime n = isPrime n && isPrime ( findSumn n )

solution :: [Int]
solution = filter isNicePrime [501..999]
