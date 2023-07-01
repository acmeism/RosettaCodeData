import Text.Printf (printf)
import Data.Numbers.Primes (isPrime, primes)

main = do
  printf "First 35 safe primes: %s\n" (show $ take 35 safe)
  printf "There are %d safe primes below 100,000.\n" (length $ takeWhile (<1000000) safe)
  printf "There are %d safe primes below 10,000,000.\n\n" (length $ takeWhile (<10000000) safe)

  printf "First 40 unsafe primes: %s\n" (show $ take 40 unsafe)
  printf "There are %d unsafe primes below 100,000.\n" (length $ takeWhile (<1000000) unsafe)
  printf "There are %d unsafe primes below 10,000,000.\n\n" (length $ takeWhile (<10000000) unsafe)

  where safe = filter (\n -> isPrime ((n-1) `div` 2)) primes
        unsafe = filter (\n -> not (isPrime((n-1) `div` 2))) primes
