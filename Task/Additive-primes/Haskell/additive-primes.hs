import Data.List (unfoldr)

-- infinite list of primes
primes = 2 : sieve [3,5..]
  where sieve (x:xs) = x : sieve (filter (\y -> y `mod` x /= 0) xs)

-- primarity test, effective for numbers less then billion
isPrime n = all (\p -> n `mod` p /= 0) $ takeWhile (< sqrtN) primes
  where sqrtN = round . sqrt . fromIntegral $ n

-- decimal digits of a number
digits = unfoldr f
  where f 0 = Nothing
        f n = let (q, r) = divMod n 10 in Just (r,q)

-- test for an additive prime
isAdditivePrime n = isPrime n && (isPrime . sum . digits) n
