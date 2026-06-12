import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

------------------- SUM OF FIRST N CUBES -----------------

sumOfFirstNCubes :: Integer -> Integer
sumOfFirstNCubes =
  (^ 2)
    . flip binomialCoefficient 2
    . succ


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    table " " $
      chunksOf 10 $
        show . sumOfFirstNCubes <$> [0 .. 49]


------------------------- GENERIC ------------------------

binomialCoefficient :: Integer -> Integer -> Integer
binomialCoefficient n k
  | n < k = 0
  | otherwise =
    div
      (factorial n)
      (factorial k * factorial (n - k))

factorial :: Integer -> Integer
factorial = product . enumFromTo 1

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
