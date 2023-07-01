import Data.Char (chr, isAlpha, ord, toLower)
import Data.Bool (bool)

rot13 :: Char -> Char
rot13 c
  | isAlpha c = chr $ bool (-) (+) ('m' >= toLower c) (ord c) 13
  | otherwise = c

-- Simple test
main :: IO ()
main = print $ rot13 <$> "Abjurer nowhere"
