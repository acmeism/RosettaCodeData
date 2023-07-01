import Data.List ( nub )
import Data.List.Split ( divvy )
import Data.Char ( digitToInt )

isColourful :: Integer -> Bool
isColourful n
   |n >= 0 && n <= 10 = True
   |n > 10 && n < 100 = ((length s) == (length $ nub s)) &&
    (not $ any (\c -> elem c "01") s)
   |n >= 100 = ((length s) == (length $ nub s)) && (not $ any (\c -> elem c "01") s)
     && ((length products) == (length $ nub products))
    where
     s :: String
     s = show n
     products :: [Int]
     products = map (\p -> (digitToInt $ head p) * (digitToInt $ last p))
      $ divvy 2 1 s

solution1 :: [Integer]
solution1 = filter isColourful [0 .. 100]

solution2 :: Integer
solution2 = head $ filter isColourful [98765432, 98765431 ..]
