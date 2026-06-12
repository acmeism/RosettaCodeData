import Data.Numbers.Primes

palindromicPrimes :: [Integer]
palindromicPrimes =
  filter (((==) <*> reverse) . show) primes

main :: IO ()
main =
  mapM_ print $
    takeWhile
      (1000 >)
      palindromicPrimes
