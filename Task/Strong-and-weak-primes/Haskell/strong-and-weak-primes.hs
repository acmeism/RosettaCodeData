import Text.Printf (printf)
import Data.Numbers.Primes (primes)

xPrimes :: (Real a, Fractional b) => (b -> b -> Bool) -> [a] -> [a]
xPrimes op ps@(p1:p2:p3:xs)
  | realToFrac p2 `op` (realToFrac (p1 + p3) / 2) = p2 : xPrimes op (tail ps)
  | otherwise = xPrimes op (tail ps)

main :: IO ()
main = do
  printf "First 36 strong primes: %s\n" . show . take 36 $ strongPrimes
  printf "Strong primes below 1,000,000: %d\n" . length . takeWhile (<1000000) $ strongPrimes
  printf "Strong primes below 10,000,000: %d\n\n" . length . takeWhile (<10000000) $ strongPrimes

  printf "First 37 weak primes: %s\n" . show . take 37 $ weakPrimes
  printf "Weak primes below 1,000,000: %d\n" . length . takeWhile (<1000000) $ weakPrimes
  printf "Weak primes below 10,000,000: %d\n\n" . length . takeWhile (<10000000) $ weakPrimes
  where strongPrimes = xPrimes (>) primes
        weakPrimes   = xPrimes (<) primes
