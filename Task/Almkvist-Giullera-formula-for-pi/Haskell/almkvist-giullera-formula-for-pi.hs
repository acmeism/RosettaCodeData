import Control.Monad
import Data.Number.CReal
import GHC.Integer
import Text.Printf

iterations = 52
main = do
  printf "N. %44s %4s %s\n"
          "Integral part of Nth term" "×10^" "=Actual value of Nth term"

  forM_ [0..9] $ \n ->
    printf "%d. %44d %4d %s\n" n
                               (almkvistGiulleraIntegral n)
                               (tenExponent n)
                               (showCReal 50 (almkvistGiullera n))

  printf "\nPi after %d iterations:\n" iterations
  putStrLn $ showCReal 70 $ almkvistGiulleraPi iterations

-- The integral part of the Nth term in the Almkvist-Giullera series
almkvistGiulleraIntegral n =
  let polynomial  = (532 `timesInteger` n `timesInteger` n) `plusInteger` (126 `timesInteger` n) `plusInteger` 9
      numerator   = 32 `timesInteger` (facInteger (6 `timesInteger` n)) `timesInteger` polynomial
      denominator = 3 `timesInteger` (powInteger (facInteger n) 6)
   in numerator `divInteger` denominator

-- The exponent for 10 in the Nth term of the series
tenExponent n = 3 `minusInteger` (6 `timesInteger` (1 `plusInteger` n))

-- The Nth term in the series (integral * 10^tenExponent)
almkvistGiullera n = fromInteger (almkvistGiulleraIntegral n) / fromInteger (powInteger 10 (abs (tenExponent n)))

-- The sum of the first N terms
almkvistGiulleraSum n = sum $ map almkvistGiullera [0 .. n]

-- The approximation of pi from the first N terms
almkvistGiulleraPi n = sqrt $ 1 / almkvistGiulleraSum n

-- Utility: factorial for arbitrary-precision integers
facInteger n = if n `leInteger` 1 then 1 else n `timesInteger` facInteger (n `minusInteger` 1)

-- Utility: exponentiation for arbitrary-precision integers
powInteger 1 _ = 1
powInteger _ 0 = 1
powInteger b 1 = b
powInteger b e = b `timesInteger` powInteger b (e `minusInteger` 1)
