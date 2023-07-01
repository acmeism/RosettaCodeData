import Data.Char (chr, ord)
import Numeric (showIntAtBase)

-- The remainder and quotient of n/d, where the remainder is guaranteed to be
-- non-negative.  The divisor, d, is assumed to be negative.
quotRemP :: Integral a => a -> a -> (a, a)
quotRemP n d = let (q, r) = quotRem n d
               in if r < 0 then (q+1, r-d) else (q, r)

-- Convert the number n to base b, where b is assumed to be less than zero.
toNegBase :: Integral a => a -> a -> a
toNegBase b n = let (q, r) = quotRemP n b
                in if q == 0 then r else negate b * toNegBase b q + r

-- Convert n to a string, where n is assumed to be a base b number, with b less
-- than zero.
showAtBase :: (Integral a, Show a) => a -> a -> String
showAtBase b n = showIntAtBase (abs b) charOf n ""
  where charOf m | m < 10    = chr $ m + ord '0'
                 | m < 36    = chr $ m + ord 'a' - 10
                 | otherwise = '?'

-- Print a number in base b, where b is assumed to be less than zero.
printAtBase :: (Integral a, Show a) => a -> a -> IO ()
printAtBase b = putStrLn . showAtBase b . toNegBase b

main :: IO ()
main = do
  printAtBase (-2)  10
  printAtBase (-3)  146
  printAtBase (-10) 15
  printAtBase (-16) 107
  printAtBase (-36) 41371458
