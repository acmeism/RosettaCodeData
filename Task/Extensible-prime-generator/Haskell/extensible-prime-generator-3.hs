{-# LANGUAGE PostfixOperators #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE FlexibleInstances #-}

import Data.Numbers.Primes
import Data.Array.Unboxed hiding ((!))
import qualified Data.Array.Unboxed as Array
import Data.CReal
import Data.CReal.Internal
import GHC.TypeLits

instance KnownNat n => Enum (CReal n) where
  toEnum i         = fromIntegral i
  fromEnum _       = error "Cannot fromEnum CReal"
  enumFrom         = iterate (+ 1)
  enumFromTo n e   = takeWhile (<= e) $ iterate (+ 1)n
  enumFromThen n m = iterate (+(m-n)) n
  enumFromThenTo n m e = if m >= n then takeWhile (<= e) $ iterate (+(m-n)) n
                          else takeWhile (>= e) $ iterate (+(m-n)) n


-- partial_sum x y a b = (p,q) where
-- p/q = sum_{a<i<=b}  x(i) / poduct_{a<j<=j} y(j)
-- The complexity of partial_sum x y 0 n is O(n log n)
partial_sum x y = pq where
    pq a b = if a>=b then (0,1)
         else if a==b-1 then (fromIntegral $ x b, fromIntegral $ y b )
         else (p_ab,q_ab)
         where
           c=(a+b) `div` 2
           (p_ac,q_ac) = pq a c
           (p_cb,q_cb) = pq c b
           p_ab = p_cb + q_cb*p_ac
           q_ab = q_ac*q_cb

-- c is the real constant that is used in the formula for primes
-- c = sum_{1<i} p_i / (2i+1)!
-- where p_i is i-th prime.
-- This will work for any sequence of integers p, where |p_n| < 2n(2n+1) * 0.375
c = crMemoize f where
  f n = 2^n * p `div` q  where
    n' = fromIntegral n
    u = head [ceiling (x) | x<-[(n' * log 2/ (log n'-1)/2 ) ..] , 2*x*log (2*x) - 2*x > n'*log 2]
    -- Invariant: (2u+1)! > 2^n
    ar :: UArray Int  Int
    ar = listArray (1,u) $ primes
    (p,q) = partial_sum (ar Array.!) (\n-> 2*n*(2*n+1) ) 0 u


-- Fractorial part of x
-- By definition it is in the interval [-0.5; 0.5]
-- But it gurantes to work corectly if fractional part of x is in (-0.375; 0.375)
fract x = x - fromIntegral (round (x :: CReal 3))

-- Factorial.
-- The complexity of (n!) is O(n log n) (which is better than O(n^2) for product [1..n] )
(!) :: (RealFrac a, Num b) => a -> b
(!) = fromIntegral . snd . partial_sum (const 0) id 0 . round

-- Analytic function for n-th prime.
-- NB. Strictly speaking this function is not analytic, because it uses factorial, fractional part and round functions
-- To make it truly analytic you need to replace
--   fract x = acos (cos (2*pi*x)) / (2*pi)
--   round x = x - fract x
-- and use the Gamma function instead of factorial.
-- Then you will get analytic function prime :: CReal 0 -> CReal 0

prime n = round( 2*n*(2*n+1) * fract ( c * ((2*n-1)!)))
