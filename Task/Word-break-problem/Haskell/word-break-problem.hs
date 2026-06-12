import Data.List (isPrefixOf, intercalate)
import Data.Tree (Tree(..))

wordBreaks :: [String] -> String -> String
wordBreaks ws = (++) <*> (":\n" ++) . report . fmap go . tokenTrees ws
  where
    go t
      | null (subForest t) = [rootLabel t]
      | otherwise = subForest t >>= ((:) (rootLabel t) . go)
    report xs
      | null xs = "\tNot parseable with these words"
      | otherwise = unlines $ ('\t' :) . intercalate " -> " <$> xs

tokenTrees :: [String] -> String -> [Tree String]
tokenTrees ws = go
  where
    go s
      | s `elem` ws = [Node s []]
      | otherwise = ws >>= next s
    next s w
      | w `isPrefixOf` s = parse w (go (drop (length w) s))
      | otherwise = []
    parse w xs
      | null xs = []
      | otherwise = [Node w xs]

-------------------------- TEST ---------------------------
ws, texts :: [String]
ws = words "a bc abc cd b"

texts = words "abcd abbc abcbcd acdbc abcdd"

main :: IO ()
main = (putStrLn . unlines) $ wordBreaks ws <$> texts
