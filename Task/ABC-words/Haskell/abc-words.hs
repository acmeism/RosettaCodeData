import Data.List (elemIndex)
import Data.Maybe (isJust)

------------------------ ABC WORDS -----------------------

isABC :: String -> Bool
isABC s =
  isJust $
    residue "bc" 'a' s
      >>= residue "c" 'b'
      >>= elemIndex 'c'

residue :: String -> Char -> String -> Maybe String
residue except c = go
  where
    go [] = Nothing
    go (x : xs)
      | x `elem` except = Nothing
      | c == x = Just xs
      | otherwise = go xs

--------------------------- TEST -------------------------
main :: IO ()
main =
  readFile "unixdict.txt"
    >>= mapM_ print . zip [1 ..] . filter isABC . lines
