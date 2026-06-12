import Data.List (group, sort)
import Data.List.Split (chunksOf)
import Data.Numbers.Primes (isPrime, primeFactors)

---------------------- CALMO NUMBERS ---------------------

isCalmo :: Int -> Bool
isCalmo n =
  let xs = properDivisors n
      m = length xs
   in m > 3
        && 0 == mod (pred m) 3
        && all (isPrime . sum) (chunksOf 3 $ tail xs)


--------------------------- TEST -------------------------
main :: IO ()
main = print $ takeWhile (< 1000) $ filter isCalmo [1 ..]


------------------------- GENERIC ------------------------

properDivisors :: Int -> [Int]
properDivisors =
  init
    . sort
    . foldr --
      (flip ((<*>) . fmap (*)) . scanl (*) 1)
      [1]
    . group
    . primeFactors
