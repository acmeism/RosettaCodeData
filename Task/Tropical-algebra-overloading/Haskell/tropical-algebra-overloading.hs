{-# LANGUAGE DataKinds, DerivingVia, FlexibleInstances, StandaloneDeriving #-}

import Prelude hiding ((^))
import Data.Monoid (Sum(Sum))
import Data.Number.CReal (CReal)
import Data.Semiring (Semiring, (^), plus, times)
import Data.Semiring.Tropical (Tropical(..), Extrema(Maxima))

-- Create our max-plus semiring over the constructive reals (CReal), using the
-- Tropical type from the semirings package.  (We'll put all the boilerplate
-- code after the main function.)
--
-- 'Maxima indicates that our semiring is a max-plus semiring, where the plus
-- function is maximum, the times function is addition, and the Infinity
-- constructor is treated as -∞.

newtype MaxPlus = MaxPlus (Tropical 'Maxima CReal)

-- Symbolic aliases to satisfy the problem requirements.

(⊕), (⊗) :: MaxPlus -> MaxPlus -> MaxPlus
(⊕) = plus
(⊗) = times

infixl 6 ⊕
infixl 7 ⊗

(↑) :: Integral a => MaxPlus -> a -> MaxPlus
(↑) = (^)

infixr 8 ↑

main :: IO ()
main = do
  --          Description                  Equation             Expected Value
  test "2 ⊗ (-2) == 0"           (2 ⊗ (-2))                  0
  test "-0.001 ⊕ -Inf == -0.001" (-0.001 ⊕ MaxPlus Infinity) (-0.001)
  test "0 ⊗ -Inf == -Inf"        (0 ⊗ MaxPlus Infinity)      (MaxPlus Infinity)
  test "1.5 ⊕ -1 == 1.5"         (1.5 ⊕ (-1))                1.5
  test "-0.5 ⊗ 0 == -0.5"        ((-0.5) ⊗ 0)                (-0.5)
  test "5 ↑ 7 == 35"             (5 ↑ 7)                     35
  test "5 ⊗ (8 ⊕ 7) == 13"       (5 ⊗ (8 ⊕ 7))               13
  test "5 ⊗ 8 ⊕ 5 ⊗ 7 == 13"     (5 ⊗ 8 ⊕ 5 ⊗ 7)             13

--------------------------------------------------------------------------------

-- Boilerplate, utility functions, etc.

-- Bootstrap our way to having MaxPlus be a Semiring instance.  Also, derive
-- Eq and Ord instances.
deriving via (Sum CReal) instance Semigroup CReal
deriving via (Sum CReal) instance Monoid CReal
deriving via Tropical 'Maxima CReal instance Semiring MaxPlus
deriving via Tropical 'Maxima CReal instance Eq MaxPlus
deriving via Tropical 'Maxima CReal instance Ord MaxPlus

-- Create a Num instance for MaxPlus mostly so that we can use fromInteger and
-- negate.  This lets us treat the numeric literal -2, for example, as a value
-- in our semiring.
instance Num MaxPlus where
  (+) = plus
  (*) = times
  abs = opError "absolute value"
  signum (MaxPlus Infinity) = -1
  signum x = wrap . signum . unwrap $ x
  fromInteger = wrap . fromInteger
  negate (MaxPlus Infinity) = opError "negation of -Inf"
  negate x = wrap . negate . unwrap $ x

-- Similar to Num, this will let us treat numeric literals, like 0.001, as
-- MaxPlus values.
instance Fractional MaxPlus where
  fromRational = wrap . fromRational
  recip _ = opError "reciprocal"

instance Show MaxPlus where
  show (MaxPlus Infinity) = "-Inf"
  show x = show . unwrap $ x

-- Test two expressions for equality.
test :: String -> MaxPlus -> MaxPlus -> IO ()
test s actual expected = do
  putStr $ "Expecting " ++ s ++ ".  Got " ++ show actual ++ " "
  putStrLn $ if actual == expected then "✔" else "✘"

-- Utility functions.

wrap :: CReal -> MaxPlus
wrap = MaxPlus . Tropical

unwrap :: MaxPlus -> CReal
unwrap (MaxPlus (Tropical x)) = x
unwrap (MaxPlus Infinity) = error "can't convert -Inf to a CReal"

opError :: String -> a
opError op = error $ op ++ " is not defined on a max-plus semiring"
