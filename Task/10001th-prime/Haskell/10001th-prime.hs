primes :: [Int]
primes = (2 :) $ filter ( \n -> and $ map ((/= 0) . (rem n)) $ takeWhile ((<= n) . (^ 2)) $ primes ) $ [3,5..]

main = print $ primes !! 10000
