import Data.Char (ord, chr, isUpper, isAlpha)
import Data.Bool (bool)

caesar, uncaesar :: Int -> String -> String
caesar = fmap . tr

uncaesar = caesar . negate

tr :: Int -> Char -> Char
tr offset c
  | isAlpha c =
    let i = ord $ bool 'a' 'A' (isUpper c)
    in chr $ i + mod ((ord c - i) + offset) 26
  | otherwise = c

main :: IO ()
main = mapM_ print [encoded, decoded]
  where
    encoded = caesar (-114) "Curio, Cesare venne, e vide e vinse ? "
    decoded = uncaesar (-114) encoded
