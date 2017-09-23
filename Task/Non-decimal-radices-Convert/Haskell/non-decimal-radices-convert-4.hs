import Data.List (unfoldr)
import Data.Char (intToDigit)

inBaseDigits :: [Char] -> Int -> String
inBaseDigits ds n =
  let base = length ds
  in reverse $
     unfoldr
       (\x ->
           (if x > 0
              then let (d, r) = quotRem x base
                   in Just (ds !! r, d)
              else Nothing))
       n

inLowerHex :: Int -> String
inLowerHex = inBaseDigits "0123456789abcdef"

inUpperHex :: Int -> String
inUpperHex = inBaseDigits "0123456789ABCDEF"

inBinary :: Int -> String
inBinary = inBaseDigits "01"

inOctal :: Int -> String
inOctal = inBaseDigits "01234567"

inDevanagariDecimal :: Int -> String
inDevanagariDecimal = inBaseDigits "०१२३४५६७८९"

inHinduArabicDecimal :: Int -> String
inHinduArabicDecimal = inBaseDigits "٠١٢٣٤٥٦٧٨٩"

toBase :: Int -> Int -> String
toBase intBase n =
  if (intBase < 36) && (intBase > 0)
    then inBaseDigits (take intBase (['0' .. '9'] ++ ['a' .. 'z'])) n
    else []

main :: IO ()
main =
  mapM_ putStrLn $
  [ inLowerHex
  , inUpperHex
  , inBinary
  , inOctal
  , toBase 16
  , toBase 2
  , inDevanagariDecimal
  , inHinduArabicDecimal
  ] <*>
  [254]
