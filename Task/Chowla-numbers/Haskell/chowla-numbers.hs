import Control.Concurrent       (setNumCapabilities)
import Control.Monad.Par        (runPar, get, spawnP)
import Control.Monad            (join, (>=>))
import Data.List.Split          (chunksOf)
import Data.List                (intercalate, mapAccumL, genericTake, genericDrop)
import Data.Bifunctor           (bimap)
import GHC.Conc                 (getNumProcessors)
import Math.NumberTheory.Primes (factorise, unPrime)
import Text.Printf              (printf)

chowla :: Word -> Word
chowla 1 = 0
chowla n = f n
  where
    f = (-) =<< pred . product . fmap sumFactor . factorise
    sumFactor (n, e) = foldr (\p s -> s + unPrime n^p) 1 [1..e]

chowlas :: [Word] -> [(Word, Word)]
chowlas [] = []
chowlas xs = runPar $ join <$>
  (mapM (spawnP . fmap ((,) <*> chowla)) >=> mapM get) (chunksOf (10^6) xs)

chowlaPrimes :: [(Word, Word)] -> (Word, Word) -> (Word, Word)
chowlaPrimes chowlas range = (count chowlas, snd range)
  where
    isPrime (1, n) = False
    isPrime (_, n) = n == 0
    count = fromIntegral . length . filter isPrime . between range
    between (min, max) = genericTake (max - pred min) . genericDrop (pred min)

chowlaPerfects :: [(Word, Word)] -> [Word]
chowlaPerfects = fmap fst . filter isPerfect
  where
    isPerfect (1, _) = False
    isPerfect (n, c) = c == pred n

commas :: (Show a, Integral a) => a -> String
commas = reverse . intercalate "," . chunksOf 3 . reverse . show

main :: IO ()
main = do
  cores <- getNumProcessors
  setNumCapabilities cores
  printf "Using %d cores\n" cores

  mapM_ (uncurry (printf "chowla(%2d) = %d\n")) $ take 37 allChowlas
  mapM_ (uncurry (printf "There are %8s primes < %10s\n"))
    (chowlaP
       [ (1, 10^2)
       , (succ $ 10^2, 10^3)
       , (succ $ 10^3, 10^4)
       , (succ $ 10^4, 10^5)
       , (succ $ 10^5, 10^6)
       , (succ $ 10^6, 10^7) ])

  mapM_ (printf "%10s is a perfect number.\n" . commas) perfects
  printf "There are %2d perfect numbers < 35,000,000\n" $ length perfects
  where
    chowlaP = fmap (bimap commas commas) . snd
      . mapAccumL (\total (count, max) -> (total + count, (total + count, max))) 0
      . fmap (chowlaPrimes $ take (10^7) allChowlas)
    perfects = chowlaPerfects allChowlas
    allChowlas = chowlas [1..35*10^6]
