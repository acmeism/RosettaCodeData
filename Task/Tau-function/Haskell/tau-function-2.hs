import Data.Numbers.Primes
import Data.List (group, intercalate, transpose)
import Data.List.Split (chunksOf)
import Text.Printf

----------------------- OEISA000005 ----------------------

oeisA000005 :: [Int]
oeisA000005 = tau <$> [1..]

tau :: Integer -> Int
tau = product . fmap (succ . length) . group . primeFactors


--------------------------- TEST -------------------------

main :: IO ()
main = putStrLn $
  (table "   " . chunksOf 10 . fmap show . take 100)
  oeisA000005


------------------------ FORMATTING ----------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
