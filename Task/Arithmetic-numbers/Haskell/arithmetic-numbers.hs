import Data.Numbers.Primes
import Data.List

import Text.Printf
import Data.List.Split
import Control.Monad

isArithCompo :: Int -> (Bool, Bool)
isArithCompo n = (mod sumFs numFs == 0, numFs > 2)
  where
    pks = map (\xs -> (head xs, length xs)) $ group $ primeFactors n
    sumFs = product [div (pred $ p ^ succ k) (pred p) | (p,k) <- pks]
    numFs = product $ map (succ . snd) pks

task1 :: [Int]
task1 = take 100 [i | i <- [1 ..], fst $ isArithCompo i]

task23 :: [(Int, Int, Int)]
task23 = map sub [10^3,10^4,10^5,10^6]
  where
    sub cnt = (cnt, fst $ ics !! pred cnt, length $ filter snd $ take cnt ics)
    ics = [(i, c) | i <- [1 ..], let (a, c) = isArithCompo i, a]

main :: IO ()
main = do
  forM_ (chunksOf 10 $ map (printf "%4d") task1) (\as -> sequence_ as >> putChar '\n')
  putChar '\n'
  forM_ task23 (\(i,a,c) -> do
    printf "%dth arithmetic number is %d\n" i a
    printf "Number of composite arithmetic numbers <= %d: %d\n\n" a c
    )
