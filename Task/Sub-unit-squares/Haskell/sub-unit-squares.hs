import Data.Char ( digitToInt , intToDigit )

isSquareNumber :: Int -> Bool
isSquareNumber n = root * root == n
 where
  root :: Int
  root = floor $ sqrt $ fromIntegral n

isSubunitSquare :: Int -> Bool
isSubunitSquare n
   |elem '0' numstr = False
   |otherwise = isSquareNumber n && isSquareNumber subunitnum
   where
    numstr :: String
    numstr = show n
    subunitnum :: Int
    subunitnum = read $ map (intToDigit . pred . digitToInt ) numstr

solution :: [Int]
solution = take 7 $ filter isSubunitSquare [1,2..]
