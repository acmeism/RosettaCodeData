import Data.Numbers.Primes
import Data.List

kempner :: Int -> Int
kempner 1 = 1
kempner n = maximum
  [ key (head ps) (length ps)
  | ps <- group $ primeFactors n ]
  where
    key p a = a * pred p + sum ks
      where
        as = takeWhile (a >=) $ iterate (succ . (p *)) 1
        ks = map fst $ scanr (\ai (_, r) -> divMod r ai) (0, a) as

theRange :: [Int]
theRange =  [77135679311 .. 77135679321]
