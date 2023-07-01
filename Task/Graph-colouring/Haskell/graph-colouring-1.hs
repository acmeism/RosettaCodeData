import Data.Maybe
import Data.List
import Control.Monad.State
import qualified Data.Map as M
import Text.Printf

------------------------------------------------------------
-- Primitive graph representation

type Node = Int
type Color = Int
type Graph = M.Map Node [Node]

nodes :: Graph -> [Node]
nodes = M.keys

adjacentNodes :: Graph -> Node -> [Node]
adjacentNodes g n = fromMaybe [] $ M.lookup n g

degree :: Graph -> Node -> Int
degree g = length . adjacentNodes g

fromList :: [(Node, [Node])] -> Graph
fromList  = foldr add M.empty
  where
    add (a, bs) g = foldr (join [a]) (join bs a g) bs
    join = flip (M.insertWith (++))

readGraph :: String -> Graph
readGraph = fromList . map interprete . words
  where
    interprete s = case span (/= '-') s of
      (a, "") -> (read a, [])
      (a, '-':b) -> (read a, [read b])

------------------------------------------------------------
-- Graph coloring functions

uncolored :: Node -> State [(Node, Color)] Bool
uncolored n = isNothing <$> colorOf n

colorOf :: Node -> State [(Node, Color)] (Maybe Color)
colorOf n = gets (lookup n)

greedyColoring :: Graph -> [(Node, Color)]
greedyColoring g = mapM_ go (nodes g) `execState` []
  where
    go n = do
      c <- colorOf n
      when (isNothing c) $ do
        adjacentColors <- nub . catMaybes <$> mapM colorOf (adjacentNodes g n)
        let newColor = head $ filter (`notElem` adjacentColors) [1..]
        modify ((n, newColor) :)
      filterM uncolored (adjacentNodes g n) >>= mapM_ go

wpColoring :: Graph -> [(Node, Color)]
wpColoring g = go [1..] nodesList `execState` []
  where
    nodesList = sortOn (negate . degree g) (nodes g)

    go _ [] = pure ()
    go (c:cs) ns = do
      mark c ns
      filterM uncolored ns >>= go cs

    mark c [] = pure () :: State [(Node, Color)] ()
    mark c (n:ns) = do
      modify ((n, c) :)
      mark c (filter (`notElem` adjacentNodes g n) ns)
