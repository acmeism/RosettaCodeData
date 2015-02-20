{-# OPTIONS_GHC -fno-warn-duplicate-constraints #-}
{-# LANGUAGE RankNTypes #-}

import Data.Array (Array, Ix)
import Data.Array.Base

-- | Element-wise combine the values of two arrays 'a' and 'b' with 'f'.
-- 'a' and 'b' must have the same bounds.
zipWithA :: (IArray arr a, IArray arr b, IArray arr c, Ix i) =>
            (a -> b -> c) -> arr i a -> arr i b -> arr i c
zipWithA f a b =
  case bounds a of
    ba ->
      if ba /= bounds b
      then error "elemwise: bounds mismatch"
      else
        let n = numElements a
        in unsafeArray ba [ (i, f (unsafeAt a i) (unsafeAt b i))
                          | i <- [0 .. n - 1]]

-- Convenient aliases for matrix-matrix element-wise operations.
type ElemOp a b c = (IArray arr a, IArray arr b, IArray arr c, Ix i) =>
                    arr i a -> arr i b -> arr i c
type ElemOp1 a = ElemOp a a a

infixl 6 +:, -:
infixl 7 *:, /:, `divE`

(+:), (-:), (*:) :: (Num a) => ElemOp1 a
(+:) = zipWithA (+)
(-:) = zipWithA (-)
(*:) = zipWithA (*)

divE :: (Integral a) => ElemOp1 a
divE = zipWithA div

(/:) :: (Fractional a) => ElemOp1 a
(/:) = zipWithA (/)

infixr 8 ^:, **:, ^^:

(^:) :: (Num a, Integral b) => ElemOp a b a
(^:) = zipWithA (^)

(**:) :: (Floating a) => ElemOp1 a
(**:) = zipWithA (**)

(^^:) :: (Fractional a, Integral b) => ElemOp a b a
(^^:) = zipWithA (^^)

-- Convenient aliases for matrix-scalar element-wise operations.
type ScalarOp a b c = (IArray arr a, IArray arr c, Ix i) =>
                      arr i a -> b -> arr i c
type ScalarOp1 a = ScalarOp a a a

samap :: (IArray arr a, IArray arr c, Ix i) =>
         (a -> b -> c) -> arr i a -> b -> arr i c
samap f a s = amap (`f` s) a

infixl 6 +., -.
infixl 7 *., /., `divS`

(+.), (-.), (*.) :: (Num a) => ScalarOp1 a
(+.) = samap (+)
(-.) = samap (-)
(*.) = samap (*)

divS :: (Integral a) => ScalarOp1 a
divS = samap div

(/.) :: (Fractional a) => ScalarOp1 a
(/.) = samap (/)

infixr 8 ^., **., ^^.

(^.) :: (Num a, Integral b) => ScalarOp a b a
(^.) = samap (^)

(**.) :: (Floating a) => ScalarOp1 a
(**.) = samap (**)

(^^.) :: (Fractional a, Integral b) => ScalarOp a b a
(^^.) = samap (^^)

main :: IO ()
main = do
  let m1, m2 :: (forall a. (Enum a, Num a) => Array (Int, Int) a)
      m1 = listArray ((0, 0), (2, 3)) [1..]
      m2 = listArray ((0, 0), (2, 3)) [10..]
      s :: (forall a. Num a => a)
      s = 99
  putStrLn "m1"
  print m1
  putStrLn "m2"
  print m2
  putStrLn "s"
  print s
  putStrLn "m1 + m2"
  print $ m1 +: m2
  putStrLn "m1 - m2"
  print $ m1 -: m2
  putStrLn "m1 * m2"
  print $ m1 *: m2
  putStrLn "m1 `div` m2"
  print $ m1 `divE` m2
  putStrLn "m1 / m2"
  print $ m1 /: m2
  putStrLn "m1 ^ m2"
  print $ m1 ^: m2
  putStrLn "m1 ** m2"
  print $ m1 **: m2
  putStrLn "m1 ^^ m2"
  print $ m1 ^^: m2
  putStrLn "m1 + s"
  print $ m1 +. s
  putStrLn "m1 - s"
  print $ m1 -. s
  putStrLn "m1 * s"
  print $ m1 *. s
  putStrLn "m1 `div` s"
  print $ m1 `divS` s
  putStrLn "m1 / s"
  print $ m1 /. s
  putStrLn "m1 ^ s"
  print $ m1 ^. s
  putStrLn "m1 ** s"
  print $ m1 **. s
  putStrLn "m1 ^^ s"
  print $ m1 ^^. s
