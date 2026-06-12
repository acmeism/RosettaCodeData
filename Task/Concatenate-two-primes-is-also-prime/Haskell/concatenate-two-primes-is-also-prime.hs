import Control.Applicative
import Data.List ( sort )
import Data.List.Split ( chunksOf )

isPrime :: Int -> Bool
isPrime n
   |n == 2 = True
   |n == 1 = False
   |otherwise = null $ filter (\i -> mod n i == 0 ) [2 .. root]
   where
      root :: Int
      root = floor $ sqrt $ fromIntegral n

solution :: [Int]
solution = sort $ filter isPrime $ map read ( (++) <$> numberlist <*> numberlist )
 where
   numberlist :: [String]
   numberlist = map show $ filter isPrime [1 .. 99]

main :: IO ( )
main = do
  mapM_ print $ chunksOf 15 solution
