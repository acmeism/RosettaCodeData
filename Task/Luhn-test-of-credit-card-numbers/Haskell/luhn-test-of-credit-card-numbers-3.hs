import Data.Char (digitToInt)

luhn :: String -> Bool
luhn x = rem (s1 + s2) 10 == 0
  where
    stringInts = fmap digitToInt
    (odds, evens) = oddsEvens (stringInts $ reverse x)
    s1 = sum odds
    s2 = sum $ sum . stringInts . show . (2 *) <$> evens

oddsEvens :: [a] -> ([a], [a])
oddsEvens xs =
  foldr
    (\(x, i) (os, es) ->
        (if rem i 2 /= 0
           then (x : os, es)
           else (os, x : es)))
    ([], [])
    (zip xs [1 ..])

main :: IO ()
main =
  mapM_
    (print . ((,) <*> luhn))
    ["49927398716", "49927398717", "1234567812345678", "1234567812345670"]
