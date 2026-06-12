import Data.List.Split ( divvy )

isSquare :: Int -> Bool
isSquare n = (snd $ properFraction $ sqrt $ fromIntegral n) == 0.0

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

solution :: [[Int]]
solution = filter (\li -> isSquare (last li - head li ) &&
 ( last li - head li ) > 36 ) $ divvy 2 1 $ filter isPrime [2..1000000]

printResultLine :: [Int] -> String
printResultLine list = show ( last list ) ++ " - " ++ ( show $ head list )
 ++ " = " ++ ( show ( last list - head list ))

main :: IO ( )
main = do
   let resultPairs = solution
   mapM_ (\li -> putStrLn $ printResultLine li ) resultPairs
