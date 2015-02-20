import qualified Data.Char as Char
import Text.Printf

encode :: Char -> String
encode c
  | c == ' ' = "+"
  | Char.isAlphaNum c || c `elem` "-._~" = [c]
  | otherwise = printf "%%%02X" c

urlEncode :: String -> String
urlEncode = concatMap encode

main :: IO ()
main = putStrLn $ urlEncode "http://foo bar/"
