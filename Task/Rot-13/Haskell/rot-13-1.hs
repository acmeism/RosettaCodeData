import Data.Char (isAlpha, toLower, chr, ord)

rot13 :: Char -> Char
rot13 c
  | isAlpha c = chr (if_ (toLower c <= 'm') (+) (-) (ord c) 13)
  | otherwise = c

if_ :: Bool -> a -> a -> a
if_ True x _ = x
if_ False _ y = y

-- Simple test
main :: IO ()
main = print $ rot13 <$> "Abjurer nowhere"
