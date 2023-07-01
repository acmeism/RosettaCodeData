{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}

import Text.Printf

class (Num a, Fractional a, RealFrac a) => Angle a where
  fullTurn :: a -- value of the whole turn
  mkAngle :: Double -> a
  value :: a -> Double
  fromTurn :: Double -> a
  toTurn :: a -> Double
  normalize :: a -> a

  -- conversion of angles to rotations in linear case
  fromTurn t = angle t * fullTurn
  toTurn a = value $ a / fullTurn

  -- normalizer for linear angular unit
  normalize a = a `modulo` fullTurn
    where
      modulo x r | x == r = r
                 | x < 0 = signum x * abs x `modulo` r
                 | x >= 0 = x - fromInteger (floor (x / r)) * r

-- smart constructor
angle :: Angle a => Double -> a
angle = normalize . mkAngle

-- Two transformers differ only in the order of type application.
from :: forall a b. (Angle a, Angle b) => a -> b
from = fromTurn . toTurn

to :: forall b a. (Angle a, Angle b) => a -> b
to = fromTurn . toTurn
