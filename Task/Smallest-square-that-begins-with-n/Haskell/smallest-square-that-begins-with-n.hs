import Control.Monad (join)
import Data.List (find, intercalate, isPrefixOf, transpose)
import Data.List.Split (chunksOf)
import Text.Printf (printf)

---------- FIRST SQUARE PREFIXED WITH DIGITS OF N --------

firstSquareWithPrefix :: Int -> Int
firstSquareWithPrefix n = unDigits match
  where
    ds = digits n
    Just match = find (isPrefixOf ds) squareDigits

squareDigits :: [[Int]]
squareDigits = digits . join (*) <$> [0 ..]


--------------------------- TEST -------------------------
main :: IO ()
main =
  putStrLn $
    table "  " $
      chunksOf 10 $
        show . firstSquareWithPrefix <$> [1 .. 49]

------------------------- GENERIC ------------------------

digits :: Int -> [Int]
digits = fmap (read . return) . show

unDigits :: [Int] -> Int
unDigits = foldl ((+) . (10 *)) 0

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
