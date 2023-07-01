import Data.Bifunctor (first)
import Data.List (unfoldr)
import Data.Tuple (swap)
import Data.Bool (bool)


inBaseDigits :: String -> Int -> String
inBaseDigits ds n =
  let base = length ds
  in reverse $
     unfoldr
       ((<*>)
          (bool Nothing . Just . first (ds !!) . swap . flip quotRem base)
          (0 <))
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
toBase intBase n
  | (intBase < 36) && (intBase > 0) =
    inBaseDigits (take intBase (['0' .. '9'] ++ ['a' .. 'z'])) n
  | otherwise = []

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
