import Data.List (tails, stripPrefix)
import Data.Maybe (catMaybes)

count :: Eq a => [a] -> [a] -> Int
count sub = length . catMaybes . map (stripPrefix sub) . tails
