import Data.List (find, group, sort)
import Data.Maybe (mapMaybe)
import Data.Numbers.Primes (primeFactors)

------------------------- A005179 ------------------------

a005179 :: [Int]
a005179 =
  mapMaybe
    ( \n ->
        find
          ((n ==) . succ . length . properDivisors)
          [1 ..]
    )
    [1 ..]

--------------------------- TEST -------------------------
main :: IO ()
main = print $ take 15 a005179

------------------------- GENERIC ------------------------

properDivisors :: Int -> [Int]
properDivisors =
  init
    . sort
    . foldr
      (flip ((<*>) . fmap (*)) . scanl (*) 1)
      [1]
    . group
    . primeFactors
