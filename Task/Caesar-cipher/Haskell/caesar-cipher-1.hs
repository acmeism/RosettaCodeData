module Caesar (caesar, uncaesar) where

import Data.Char

caesar, uncaesar :: (Integral a) => a -> String -> String
caesar k = map f
    where f c = case generalCategory c of
              LowercaseLetter -> addChar 'a' k c
              UppercaseLetter -> addChar 'A' k c
              _               -> c
uncaesar k = caesar (-k)

addChar :: (Integral a) => Char -> a -> Char -> Char
addChar b o c = chr $ fromIntegral (b' + (c' - b' + o) `mod` 26)
    where b' = fromIntegral $ ord b
          c' = fromIntegral $ ord c
