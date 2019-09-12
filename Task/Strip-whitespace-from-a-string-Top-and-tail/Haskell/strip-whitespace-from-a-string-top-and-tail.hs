import Data.Char (isSpace)
import Data.List (dropWhileEnd)

trimLeft :: String -> String
trimLeft = dropWhile isSpace

trimRight :: String -> String
trimRight = dropWhileEnd isSpace

trim :: String -> String
trim = trimLeft . trimRight
