import Data.Char (digitToInt)
import Data.List (transpose)
import Data.List.Split (chunksOf)

luhn :: String -> Bool
luhn x = 0 == rem (s1 + s2) 10
  where
    stringInts = fmap digitToInt
    [odds, evens] =
      (transpose . chunksOf 2)
        (stringInts $ reverse x)
    s1 = sum odds
    s2 = sum $ sum . stringInts . show . (2 *) <$> evens

main :: IO ()
main =
  mapM_
    (print . ((,) <*> luhn))
    [ "49927398716",
      "49927398717",
      "1234567812345678",
      "1234567812345670"
    ]
