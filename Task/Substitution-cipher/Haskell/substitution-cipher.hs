import Data.Char          (chr)
import Data.Maybe         (fromMaybe)
import Data.Tuple         (swap)
import System.Environment (getArgs)

data Command = Cipher String | Decipher String | Invalid

alphabet :: String
alphabet = chr <$> [32..126]

cipherMap :: [(Char, Char)]
cipherMap = zip alphabet (shuffle 20 alphabet)

shuffle :: Int -> [a] -> [a]
shuffle n xs = iterate go xs !! n
  where
    go [] = []
    go xs = go (drop 2 xs) <> take 2 xs

convert :: Eq a => [(a, a)] -> [a] -> [a]
convert m = map (\x -> fromMaybe x (lookup x m))

runCommand :: Command -> String
runCommand (Cipher s)   = convert cipherMap s
runCommand (Decipher s) = convert (swap <$> cipherMap) s
runCommand Invalid = "Invalid arguments. Usage: simplecipher c|d <text>"

parseArgs :: [String] -> Command
parseArgs (x:y:xs)
  | x == "c" = Cipher y
  | x == "d" = Decipher y
  | otherwise = Invalid
parseArgs _ = Invalid

main :: IO ()
main = parseArgs <$> getArgs >>= putStrLn . runCommand
