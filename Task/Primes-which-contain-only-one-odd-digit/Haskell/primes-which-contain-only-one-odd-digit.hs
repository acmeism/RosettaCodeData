import Data.List (intercalate, maximum, transpose)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primes)
import Text.Printf (printf)


------------------ ONE ODD DECIMAL DIGIT -----------------

oneOddDecimalDigit :: Int -> Bool
oneOddDecimalDigit =
  (1 ==) . length . filter odd . digits

digits :: Int -> [Int]
digits = fmap (read . return) . show


--------------------------- TEST -------------------------
main :: IO ()
main = do
  putStrLn "Below 1000:"
  (putStrLn . table " " . chunksOf 10 . fmap show) $
    sampleBelow 1000

  putStrLn "Count of matches below 10E6:"
  (print . length) $
    sampleBelow 1000000

sampleBelow :: Int -> [Int]
sampleBelow =
  filter oneOddDecimalDigit
    . flip takeWhile primes
    . (>)

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
