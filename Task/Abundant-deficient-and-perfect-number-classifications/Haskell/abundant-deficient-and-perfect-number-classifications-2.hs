import Data.Numbers.Primes (primeFactors)
import Data.List (group, sort)

deficientPerfectAbundantCountsUpTo :: Int -> (Int, Int, Int)
deficientPerfectAbundantCountsUpTo = foldr go (0, 0, 0) . enumFromTo 1
  where
    go x (deficient, perfect, abundant)
      | divisorSum < x = (succ deficient, perfect, abundant)
      | divisorSum > x = (deficient, perfect, succ abundant)
      | otherwise = (deficient, succ perfect, abundant)
      where
        divisorSum = sum $ properDivisors x

properDivisors :: Int -> [Int]
properDivisors = init . sort . foldr go [1] . group . primeFactors
  where
    go = flip ((<*>) . fmap (*)) . scanl (*) 1

main :: IO ()
main = print $ deficientPerfectAbundantCountsUpTo 20000
