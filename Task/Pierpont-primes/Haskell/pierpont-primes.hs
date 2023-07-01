import Control.Monad (guard)
import Data.List (intercalate)
import Data.List.Split (chunksOf)
import Math.NumberTheory.Primes (Prime, unPrime, nextPrime)
import Math.NumberTheory.Primes.Testing (isPrime)
import Text.Printf (printf)

data PierPointKind = First | Second

merge :: Ord a => [a] -> [a] -> [a]
merge [] b = b
merge a@(x:xs) b@(y:ys) | x < y     = x : merge xs b
                        | otherwise = y : merge a ys

nSmooth :: Integer -> [Integer]
nSmooth p = 1 : foldr u [] factors
 where
  factors = takeWhile (<=p) primes
  primes = map unPrime [nextPrime 1..]
  u n s = r
   where
    r = merge s (map (n*) (1:r))

pierpoints :: PierPointKind -> [Integer]
pierpoints k = do
  n <- nSmooth 3
  let x = case k of First  -> succ n
                    Second -> pred n
  guard (isPrime x) >> [x]

main :: IO ()
main = do
  printf "\nFirst 50 Pierpont primes of the first kind:\n"
  mapM_ (\row -> mapM_ (printf "%12s" . commas) row >> printf "\n") (rows $ pierpoints First)
  printf "\nFirst 50 Pierpont primes of the second kind:\n"
  mapM_ (\row -> mapM_ (printf "%12s" . commas) row >> printf "\n") (rows $ pierpoints Second)
  printf "\n250th Pierpont prime of the first kind: %s\n" (commas $ pierpoints First !! 249)
  printf "\n250th Pierpont prime of the second kind: %s\n\n" (commas $ pierpoints Second !! 249)
 where
  rows = chunksOf 10 . take 50
  commas = reverse . intercalate "," . chunksOf 3 . reverse . show
