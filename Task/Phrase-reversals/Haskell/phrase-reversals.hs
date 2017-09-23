reverseString, reverseEachWord, reverseWordOrder :: String -> String
reverseString = reverse

reverseEachWord = wordLevel (fmap reverse)

reverseWordOrder = wordLevel reverse

wordLevel :: ([String] -> [String]) -> String -> String
wordLevel f = unwords . f . words

main :: IO ()
main =
  (putStrLn . unlines) $
  [reverseString, reverseEachWord, reverseWordOrder] <*>
  ["rosetta code phrase reversal"]
