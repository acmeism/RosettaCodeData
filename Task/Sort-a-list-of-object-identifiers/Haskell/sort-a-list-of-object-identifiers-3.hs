import Data.List.Split (splitOn)
import Data.List (sort, intercalate)

-- SORTING OBJECT IDENTIFIERS ------------------------------------------------
oidSort :: [String] -> [String]
oidSort =
  fmap (intercalate "." . fmap show) . sort . fmap (fmap readInt . splitOn ".")

readInt :: String -> Int
readInt x = read x :: Int
