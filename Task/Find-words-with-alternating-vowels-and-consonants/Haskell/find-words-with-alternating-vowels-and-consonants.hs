import Control.Monad (join)
import Data.Bifunctor (bimap)
import Data.List.Split (chunksOf)

------- WORDS WITH ALTERNATING VOWELS AND CONSONANTS -----

isLongAlternator :: String -> Bool
isLongAlternator s =
  9 < length s
    && all alternating (zip s $ tail s)

alternating :: (Char, Char) -> Bool
alternating = uncurry (/=) . join bimap isVowel

isVowel :: Char -> Bool
isVowel = flip elem "aeiou"

--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= mapM_ putStrLn
      . ( ((:) . (<> " matching words:\n") . show . length)
            <*> inColumns 4
        )
      . filter isLongAlternator
      . lines

------------------------ FORMATTING ----------------------

inColumns :: Int -> [String] -> [String]
inColumns n xs = unwords <$> chunksOf n (justifyLeft w ' ' <$> xs)
  where
    w = maximum (length <$> xs)

justifyLeft :: Int -> Char -> String -> String
justifyLeft n c s = take n (s <> replicate n c)
