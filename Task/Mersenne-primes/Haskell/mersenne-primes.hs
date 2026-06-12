import Data.Numbers.Primes (primes)
import Text.Printf (printf)

lucasLehmer :: Int -> Bool
lucasLehmer p = iterate f 4 !! p-2 == 0
 where
  f b = (b^2 - 2) `mod` m
  m = 2^p - 1

main = mapM_ (printf "M %d\n") $ take 20 mersenne
 where
  mersenne = filter lucasLehmer primes
