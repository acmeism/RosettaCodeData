import Data.Numbers.Primes (primeFactors)
import Data.List (group, sort)
import Data.Bool (bool)

deficientPerfectAbundantCountsUpTo :: Int -> (Int, Int, Int)
deficientPerfectAbundantCountsUpTo n =
  foldr
    (\x (deficient, perfect, abundant) ->
        let divisorSum = sum $ properDivisors x
        in bool
             (bool
                (deficient, succ perfect, abundant)
                (deficient, perfect, succ abundant)
                (divisorSum > x))
             (succ deficient, perfect, abundant)
             (divisorSum < x))
    (0, 0, 0)
    [1 .. n :: Int]

properDivisors :: Int -> [Int]
properDivisors =
  init . sort . foldr (
    flip ((<*>) . fmap (*)) . scanl (*) 1
  ) [1] . group . primeFactors

main :: IO ()
main = print $ deficientPerfectAbundantCountsUpTo 20000
