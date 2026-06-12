import System.IO (readFile)
import Data.Bifunctor (first)


---------- MORE THAN THREE VOWELS, AND NONE BUT E --------

p :: String -> Bool
p = uncurry (&&) . first (3 <) . foldr rule (0, True)

rule :: Char -> (Int, Bool) -> (Int, Bool)
rule _ (n, False) = (n, False)
rule 'e' (n, b) = (succ n, b)
rule c (n, b)
  | c `elem` "aiou" = (n, False)
  | otherwise = (n, b)

--------------------------- TEST -------------------------
main :: IO ()
main = readFile "unixdict.txt"
  >>= (putStrLn . unlines . filter p . lines)
