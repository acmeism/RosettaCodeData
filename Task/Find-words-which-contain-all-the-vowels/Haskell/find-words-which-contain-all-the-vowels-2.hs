import Data.Set (Set, fromList, member, size)

---- WORDS OVER 10 CHARS WHICH CONTAIN EACH VOWEL ONCE ---

p :: String -> Bool
p = ((&&) . (10 <) . length) <*> eachVowelOnce

eachVowelOnce :: String -> Bool
eachVowelOnce w =
  all (5 ==) $
    [length, size . fromList] <*> [filter (`member` vowels) w]

vowels :: Set Char
vowels = fromList "aeiou"

--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= (mapM_ putStrLn . filter p . lines)
