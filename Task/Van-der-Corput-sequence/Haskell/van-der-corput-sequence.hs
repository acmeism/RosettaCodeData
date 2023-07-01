import Data.Ratio (Rational(..), (%), numerator, denominator)
import Data.List (unfoldr)
import Text.Printf (printf)

-- A wrapper type for Rationals to make them look nicer when we print them.
newtype Rat =
  Rat Rational

instance Show Rat where
  show (Rat n) = show (numerator n) <> ('/' : show (denominator n))

-- Convert a list of base b digits to its corresponding number.
-- We assume the digits are valid base b numbers and that
-- their order is from least to most significant.
digitsToNum :: Integer -> [Integer] -> Integer
digitsToNum b = foldr1 (\d acc -> b * acc + d)

-- Convert a number to the list of its base b digits.
-- The order will be from least to most significant.
numToDigits :: Integer -> Integer -> [Integer]
numToDigits _ 0 = [0]
numToDigits b n = unfoldr step n
  where
    step 0 = Nothing
    step m =
      let (q, r) = m `quotRem` b
      in Just (r, q)

-- Return the n'th element in the base b van der Corput sequence.
-- The base must be ≥ 2.
vdc :: Integer -> Integer -> Rat
vdc b n
  | b < 2 = error "vdc: base must be ≥ 2"
  | otherwise =
    let ds = reverse $ numToDigits b n
    in Rat (digitsToNum b ds % b ^ length ds)

-- Each base followed by a specified range of van der Corput numbers.
printVdcRanges :: ([Integer], [Integer]) -> IO ()
printVdcRanges (bases, nums) =
  mapM_
    putStrLn
    [ printf "Base %d:" b <> concatMap (printf " %5s" . show) rs
    | b <- bases
    , let rs = map (vdc b) nums ]

main :: IO ()
main = do
  -- Small bases:
  printVdcRanges ([2, 3, 4, 5], [0 .. 9])
  putStrLn []

  -- Base 123:
  printVdcRanges ([123], [50,100 .. 300])
