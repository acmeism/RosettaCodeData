import Data.List (group, intercalate, transpose)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes ( primeFactors )
import Text.Printf (printf)


----------------------- OEIS A111398 ---------------------

oeisA111398 :: [Integer]
oeisA111398 = 1 : [n | n <- [1..], 8 == length (divisors n)]


divisors :: Integer -> [Integer]
divisors =
  foldr
    (flip ((<*>) . fmap (*)) . scanl (*) 1)
    [1]
    . group
    . primeFactors


--------------------------- TEST -------------------------

main :: IO ()
main = do
  putStrLn $ table "   " $ chunksOf 10 $
    take 50 (show <$> oeisA111398)

  mapM_ print $
   (,) <*> ((oeisA111398 !!) . pred) <$> [500, 5000, 50000]

------------------------- DISPLAY ------------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
