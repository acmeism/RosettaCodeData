import Data.Char (chr, isAlpha, ord, toLower)
import Data.Bool (bool)

rot13 :: Char -> Char
rot13 =
  let rot = flip ((bool (-) (+) . ('m' >=) . toLower) <*> ord)
  in (bool <*> chr . rot 13) <*> isAlpha

-- Simple test
main :: IO ()
main = print $ rot13 <$> "Abjurer nowhere"
