import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (primeFactors)
import Text.Printf (printf)

----------- PRODUCT OF MIN AND MAX PRIME FACTORS ---------

oeisA066048 :: [Integer]
oeisA066048 = 1 : fmap f [2 ..]
  where
    f = ((*) . head <*> last) . primeFactors

--------------------------- TEST -------------------------
main :: IO ()
main = putStrLn $
  table "  " $ (chunksOf 10 . take 100) $
    fmap show oeisA066048

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
