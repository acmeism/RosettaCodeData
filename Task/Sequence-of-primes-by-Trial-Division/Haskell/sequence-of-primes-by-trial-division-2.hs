import Data.List (nubBy)

primes = nubBy (((>1).).gcd) [2..]
