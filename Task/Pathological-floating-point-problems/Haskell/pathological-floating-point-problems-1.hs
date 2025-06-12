-- | Show at least n decimal places

showRational :: Natural -> Rational -> String
showRational n r = let

  sign            = if r < 0 then '-' else '+'
  (integer, rest) = (numerator r `quotRem` denominator r)
  decimal         = show $ rest * 10 ^ n `quot` denominator r
  zeroes          = replicate (fromIntegral n - length decimal) '0'

  in sign : show integer ++ "." ++ zeroes ++ decimal
