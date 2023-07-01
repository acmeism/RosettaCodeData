{-# LANGUAGE KindSignatures, DataKinds  #-}

import Data.Ratio
import Data.List (find)
import GHC.TypeLits
import Padic

pSqrt :: KnownNat p => Rational -> Padic p
pSqrt r = res
  where
    res = maybe Null mkUnit series
    (a, b) = (numerator r, denominator r)
    series = case modulo res of

      2 | eqMod 4 a 3 -> Nothing
        | not (eqMod 8 a 1) -> Nothing
        | otherwise -> Just $ 1 : 0 : go 8 1
        where
          go pk x =
            let q = ((b*x*x - a) `div` pk) `mod` 2
            in q : go (2*pk) (x + q * (pk `div` 2))

      p -> do
        y <- find (\x -> eqMod p (b*x*x) a) [1..p-1]
        df <- recipMod p (2*b*y)
        let go pk x =
              let f = (b*x*x - a) `div` pk
                  d = (f * (p - df)) `mod` p
              in x `div` (pk `div` p) : go (p*pk) (x + d*pk)
        Just $ go p y

eqMod :: Integral a => a -> a -> a -> Bool
eqMod p a b = a `mod` p == b `mod` p
