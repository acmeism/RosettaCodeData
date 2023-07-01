import AStar (findPath, Graph(..))
import qualified Data.Map as M

distance :: String -> String -> Int
distance s1 s2 = length $ filter not $ zipWith (==) s1 s2

wordLadder :: [String] -> String -> String -> [String]
wordLadder dict start end = findPath g distance start end
  where
    short_dict = filter ((length start ==) . length) dict
    g = Graph $ \w -> M.fromList [ (x, 1)
                                 | x <- short_dict
                                 , distance w x == 1 ]
