import Data.List (find, group)
import Data.Maybe (fromJust)

firstPrimeFactor :: Int -> Int
firstPrimeFactor n = head $ filter ((0 ==) . mod n) [2 .. n]

allPrimeFactors :: Int -> [Int]
allPrimeFactors 1 = []
allPrimeFactors n =
  let first = firstPrimeFactor n
  in first : allPrimeFactors (n `div` first)

factorCount :: Int -> Int
factorCount 1 = 1
factorCount n = product ((succ . length) <$> group (allPrimeFactors n))

divisorCount :: Int -> (Int, Int)
divisorCount = (,) <*> factorCount

hcnNext :: (Int, Int) -> (Int, Int)
hcnNext (num, factors) =
  fromJust $ find ((> factors) . snd) (divisorCount <$> [num ..])

hcnSequence :: [Int]
hcnSequence = fst <$> iterate hcnNext (1, 1)

main :: IO ()
main = print $ take 20 hcnSequence
