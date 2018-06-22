import Data.Char (intToDigit)
import Control.Monad (replicateM, forM_)

count :: Int -> [Int] -> Int
count x = length . filter (x ==)

-- all the combinations of n digits of base n
-- a base-n number are represented as a list of ints, one per digit
allBaseNNumsOfLength :: Int -> [[Int]]
allBaseNNumsOfLength = replicateM <*> (enumFromTo 0 . subtract 1)

isSelfDescribing :: [Int] -> Bool
isSelfDescribing num = all (\(i, x) -> x == count i num) $ zip [0 ..] num

-- translate it back into an integer in base-10
decimalize :: [Int] -> Int
decimalize = read . map intToDigit

main :: IO ()
main =
  (print . concat) $
  map decimalize . filter isSelfDescribing . allBaseNNumsOfLength <$> [1 .. 8]
