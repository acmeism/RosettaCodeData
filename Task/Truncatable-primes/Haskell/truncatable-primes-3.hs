digits = [1..9] :: [Integer]
smallPrimes = filter isPrime digits
pow10 = iterate (*10) 1
mul10 = (pow10!!). length. show
righT = (+) . (10 *)
lefT = liftM2 (.) (+) ((*) . mul10)

primesTruncatable f = iterate (concatMap (filter isPrime.flip map digits. f)) smallPrimes
