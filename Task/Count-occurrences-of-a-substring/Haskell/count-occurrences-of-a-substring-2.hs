import Data.Text hiding (length)

countAll :: String -> String -> Int
countAll needle haystack = length (breakOnAll n h)
  where
    [n, h] = pack <$> [needle, haystack]

main :: IO ()
main =
  print $ countAll "ab" <$> ["ababababab", "abelian absurdity", "babel kebab"]
