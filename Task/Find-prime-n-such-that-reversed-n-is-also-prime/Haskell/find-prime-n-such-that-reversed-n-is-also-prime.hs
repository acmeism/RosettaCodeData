import Data.List (intercalate, transpose)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (isPrime, primes)
import Text.Printf (printf)

------------------------ PREDICATE -----------------------

p :: Int -> Bool
p n = isPrime (read (reverse $ show n) :: Int)

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_
    putStrLn
    [ "Reversible primes below 500:",
      (table " " . chunksOf 10 . fmap show) $
        takeWhile (< 500) (filter p primes)
    ]

------------------------ FORMATTING ----------------------

table :: String -> [[String]] -> String
table gap rows =
  let widths =
        maximum . fmap length
          <$> transpose rows
   in unlines $
        fmap
          ( intercalate gap
              . zipWith
                ( printf
                    . flip intercalate ["%", "s"]
                    . show
                )
                widths
          )
          rows
