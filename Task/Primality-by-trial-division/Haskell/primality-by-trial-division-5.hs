import Data.List (nubBy)

primes = nubBy (\p x -> x `mod` p == 0) [2..]
