import Data.List (intercalate)
import Data.List.Split (splitOn)

replace :: String -> String -> String -> String
replace a b = intercalate b . splitOn a
