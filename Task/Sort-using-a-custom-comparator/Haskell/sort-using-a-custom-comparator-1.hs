import Data.List (sortBy)
import Data.Function (on)
import Data.Char (toLower)

lengthThenAZ :: String -> String -> Ordering
lengthThenAZ a b
  | d == EQ = on compare (toLower <$>) a b
  | otherwise = d
  where
    d = on compare length a b

descLengthThenAZ :: String -> String -> Ordering
descLengthThenAZ a b
  | d == EQ = on compare (toLower <$>) a b
  | otherwise = d
  where
    d = on (flip compare) length a b

xs :: [String]
xs = ["Here", "are", "some", "sample", "strings", "to", "be", "sorted"]

main :: IO ()
main =
  mapM_
    putStrLn
    [unlines $ sortBy lengthThenAZ xs, unlines $ sortBy descLengthThenAZ xs]
