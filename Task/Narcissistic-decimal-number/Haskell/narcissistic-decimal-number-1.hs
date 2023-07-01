import Data.Char (digitToInt)

isNarcissistic :: Int -> Bool
isNarcissistic n = (sum ((^ digitCount) <$> digits) ==) n
  where
    digits = digitToInt <$> show n
    digitCount = length digits

main :: IO ()
main = mapM_ print $ take 25 (filter isNarcissistic [0 ..])
