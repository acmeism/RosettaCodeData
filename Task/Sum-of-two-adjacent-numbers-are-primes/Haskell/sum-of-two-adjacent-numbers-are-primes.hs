import Data.Numbers.Primes

primeSumsOfConsecutiveNumbers :: Integral a => [(a, (a, a))]
primeSumsOfConsecutiveNumbers =
  let go a b = [(n, (a, b)) | let n = a + b, isPrime n]
   in concat $ zipWith go [1 ..] [2 ..]

main :: IO ()
main = mapM_ print $ take 20 primeSumsOfConsecutiveNumbers
