primes = 2 : sieve [3,5..]
  where sieve (x:xs) = x : sieve (filter (\y -> y `mod` x /= 0) xs)

frobenius = zipWith (\a b -> a*b - a - b) primes (tail primes)
