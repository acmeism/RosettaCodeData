{-# LANGUAGE NumericUnderscores #-}
import Control.Monad (guard)
import Math.NumberTheory.Primes.Testing (isPrime)
import Data.List.Split (chunksOf)
import Data.List (intercalate)
import Text.Printf (printf)

smarandache :: [Integer]
smarandache = [2,3,5,7] <> s [2,3,5,7] >>= \x -> guard (isPrime x) >> [x]
 where s xs = r <> s r where r = xs >>= \x -> [x*10+2, x*10+3, x*10+5, x*10+7]

nextSPDSTerms :: [Int] -> [(String, String)]
nextSPDSTerms = go 1 smarandache
 where
  go _ _ [] = []
  go c (x:xs) terms
   | c `elem` terms = (commas c, commas x) : go nextCount xs (tail terms)
   | otherwise      = go nextCount xs terms
   where nextCount = succ c

commas :: Show a => a -> String
commas = reverse . intercalate "," . chunksOf 3 . reverse . show

main :: IO ()
main = do
  printf "The first 25 SPDS:\n%s\n\n" $ f smarandache
  mapM_ (uncurry (printf "The %9sth SPDS: %15s\n")) $
    nextSPDSTerms [100, 1_000, 10_000, 100_000, 1_000_000]
 where f = show . take 25
