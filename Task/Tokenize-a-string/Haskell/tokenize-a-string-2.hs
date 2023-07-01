splitBy :: (a -> Bool) -> [a] -> [[a]]
splitBy _ [] = []
splitBy f list = first : splitBy f (dropWhile f rest) where
  (first, rest) = break f list

splitRegex :: Regex -> String -> [String]

joinWith :: [a] -> [[a]] -> [a]
joinWith d xs = concat $ List.intersperse d xs
-- "concat $ intersperse" can be replaced with "intercalate" from the Data.List in GHC 6.8 and later

putStrLn $ joinWith "." $ splitBy (== ',') $ "Hello,How,Are,You,Today"

-- using regular expression to split:
import Text.Regex
putStrLn $ joinWith "." $ splitRegex (mkRegex ",") $ "Hello,How,Are,You,Today"
