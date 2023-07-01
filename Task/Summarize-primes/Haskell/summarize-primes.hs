import Data.List (scanl)
import Data.Numbers.Primes (isPrime, primes)

--------------- PRIME SUMS OF FIRST N PRIMES -------------

indexedPrimeSums :: [(Integer, Integer, Integer)]
indexedPrimeSums =
  filter (\(_, _, n) -> isPrime n) $
    scanl
      (\(i, _, m) p -> (succ i, p, p + m))
      (0, 0, 0)
      primes

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ print $
    takeWhile (\(_, p, _) -> 1000 > p) indexedPrimeSums
