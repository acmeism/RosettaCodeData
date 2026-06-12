import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (isPrime, primes)
import Text.Printf (printf)

---------------------- COUSIN PRIMES ---------------------

cousinPrimes :: [(Integer, Integer)]
cousinPrimes = concat $ (zipWith go <*> fmap (+ 4)) primes
  where
    go a b = [(a, b) | isPrime b]


--------------------------- TEST -------------------------
main :: IO ()
main = do
  let cousins = takeWhile ((< 1000) . snd) cousinPrimes
  mapM_
    putStrLn
    [ (show . length) cousins <> " cousin prime pairs:",
      "",
      table "   " $
        chunksOf 5 $ show <$> cousins
    ]

------------------------ FORMATTING ----------------------

table :: String -> [[String]] -> String
table gap rows =
  let ws = maximum . fmap length <$> transpose rows
      pw = printf . flip intercalate ["%", "s"] . show
   in unlines $ intercalate gap . zipWith pw ws <$> rows
