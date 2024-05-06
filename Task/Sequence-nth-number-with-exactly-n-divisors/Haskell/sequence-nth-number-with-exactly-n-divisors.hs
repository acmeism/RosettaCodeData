import           Control.Monad                         (guard)
import           Math.NumberTheory.ArithmeticFunctions (divisorCount)
import           Math.NumberTheory.Primes              (Prime, unPrime)
import           Math.NumberTheory.Primes.Testing      (isPrime)

calc :: Integer -> [(Integer, Integer)]
calc n = do
  x <- [1..]
  guard (even n || odd n && f x == x)
  [(x, divisorCount x)]
 where f n = floor (sqrt $ realToFrac n) ^ 2

havingNthDivisors :: Integer -> [(Integer, Integer)]
havingNthDivisors n = filter ((==n) . snd) $ calc n

nths :: [(Integer, Integer)]
nths = do
  n <- [1..35] :: [Integer]
  if isPrime n then
    pure (n, nthPrime (fromIntegral n) ^ pred n)
  else
    pure (n, f n)
 where
  f n = fst (havingNthDivisors n !! pred (fromIntegral n))
  nthPrime n = unPrime (toEnum n :: Prime Integer)

main :: IO ()
main = mapM_ print nths
