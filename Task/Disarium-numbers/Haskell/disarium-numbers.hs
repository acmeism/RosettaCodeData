module Disarium
   where
import Data.Char ( digitToInt)

isDisarium :: Int -> Bool
isDisarium n = (sum $ map (\(c , i ) -> (digitToInt c ) ^ i )
 $ zip ( show n ) [1 , 2 ..]) == n

solution :: [Int]
solution = take 18 $ filter isDisarium [0, 1 ..]
