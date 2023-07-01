import Text.Printf         (printf)
import Data.Numbers.Primes (isPrime, primes)

type Pair = (Int, Int)
type Triplet = (Int, Int, Int)
type Quad = (Int, Int, Int, Int)
type Quin = (Int, Int, Int, Int, Int)

type Result = ([Pair], [Triplet], [Quad], [Quin], [Int])

groups :: Int -> Result -> Result
groups n r@(p, t, q, qn, u)
  | isPrime n4 && isPrime n3 && isPrime n2 && isPrime n1 = (addPair, addTriplet, addQuad, addQuin, u)
  | isPrime n3 && isPrime n2 && isPrime n1               = (addPair, addTriplet, addQuad, qn, u)
  | isPrime n2 && isPrime n1                             = (addPair, addTriplet, q, qn, u)
  | isPrime n1                                           = (addPair, t, q, qn, u)
  | not (isPrime (n+6)) && not (isPrime n1)              = (p, t, q, qn, n : u)
  | otherwise                                            = r
  where addPair    = (n1, n) : p
        addTriplet = (n2, n1, n) : t
        addQuad    = (n3, n2, n1, n) : q
        addQuin    = (n4, n3, n2, n1, n) : qn
        n1         = n - 6
        n2         = n - 12
        n3         = n - 18
        n4         = n - 24

main :: IO ()
main = do
  printf ("Number of sexy prime pairs: %d\n" <> lastFiveText) (length pairs) (lastFive pairs)
  printf ("Number of sexy prime triplets: %d\n" <> lastFiveText) (length triplets) (lastFive triplets)
  printf ("Number of sexy prime quadruplets: %d\n" <> lastFiveText) (length quads) (lastFive quads)
  printf "Number of sexy prime quintuplets: %d\n  Last 1 : %s\n\n" (length quins) (show $ last quins)
  printf "Number of unsexy primes: %d\n  Last 10: %s\n\n" (length unsexy) (show $ drop (length unsexy - 10) unsexy)
  where (pairs, triplets, quads, quins, unsexy) = foldr groups ([], [], [], [], []) $ takeWhile (< 1000035) primes
        lastFive xs = show $ drop (length xs - 5) xs
        lastFiveText = "  Last 5 : %s\n\n"
