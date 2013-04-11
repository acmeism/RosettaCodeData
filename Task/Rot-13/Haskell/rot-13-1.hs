import Data.Char

rot13 :: Char -> Char
rot13 c
  | toLower c >= 'a' && toLower c <= 'm' = chr (ord c + 13)
  | toLower c >= 'n' && toLower c <= 'z' = chr (ord c - 13)
  | otherwise = c
