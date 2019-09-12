import Data.Char (digitToInt)

luhn :: String -> Bool
luhn x = 0 == rem (s1 + s2) 10
  where
    stringInts = fmap digitToInt
    (odds, evens) = oddsEvens (stringInts $ reverse x)
    s1 = sum odds
    s2 = sum $ sum . stringInts . show . (2 *) <$> evens

oddsEvens :: [a] -> ([a], [a])
oddsEvens xs = foldr go ([], []) (zip xs [1 ..])
  where
    go (x, i) (os, es)
      | 0 /= rem i 2 = (x : os, es)
      | otherwise = (os, x : es)

main :: IO ()
main =
  mapM_
    (print . ((,) <*> luhn))
    ["49927398716", "49927398717", "1234567812345678", "1234567812345670"]
