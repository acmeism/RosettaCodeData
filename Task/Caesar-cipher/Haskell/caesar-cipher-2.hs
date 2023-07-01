import Data.Bool (bool)
import Data.Char (chr, isAlpha, isUpper, ord)

---------------------- CAESAR CIPHER ---------------------

caesar, uncaesar :: Int -> String -> String
caesar = fmap . tr
uncaesar = caesar . negate

tr :: Int -> Char -> Char
tr offset c
  | isAlpha c =
      chr
        . ((+) <*> (flip mod 26 . (-) (offset + ord c)))
        $ bool 97 65 (isUpper c)
  | otherwise = c

--------------------------- TEST -------------------------
main :: IO ()
main = do
  let k = -114
      cipher = caesar k
      plain = "Curio, Cesare venne, e vide e vinse ? "
  mapM_ putStrLn $ [cipher, uncaesar k . cipher] <*> [plain]
