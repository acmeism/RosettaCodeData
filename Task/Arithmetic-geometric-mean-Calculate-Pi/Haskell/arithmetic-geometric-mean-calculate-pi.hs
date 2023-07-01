import Prelude hiding (pi)
import Data.Number.MPFR hiding (sqrt, pi, div)
import Data.Number.MPFR.Instances.Near ()

-- A generous overshoot of the number of bits needed for a
-- given number of digits.
digitBits :: (Integral a, Num a) => a -> a
digitBits n = (n + 1) `div` 2 * 8

-- Calculate pi accurate to a given number of digits.
pi :: Integer -> MPFR
pi digits =
  let eps = fromString ("1e-" ++ show digits)
            (fromInteger $ digitBits digits) 0
      two = fromInt Near (getPrec eps) 2
      twoi = 2 :: Int
      twoI = 2 :: Integer
      pis a g s n =
        let aB = (a + g) / two
            gB = sqrt (a * g)
            aB2 = aB ^^ twoi
            sB = s + (two ^^ n) * (aB2 - gB ^^ twoi)
            num = 4 * aB2
            den = 1 - sB
        in (num / den) : pis aB gB sB (n + 1)
      puntil f (a:b:xs) = if f a b then b else puntil f (b:xs)
  in puntil (\a b -> abs (a - b) < eps)
     $ pis one (one / sqrt two) zero twoI

main :: IO ()
main = do
  -- The last decimal is rounded.
  putStrLn $ toString 1000 $ pi 1000
