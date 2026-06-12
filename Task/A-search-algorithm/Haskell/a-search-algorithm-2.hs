import PQueue
import Data.Map (Map(..))
import qualified Data.Map as Map
import Data.List (unfoldr)

newtype Graph n = Graph { links :: n -> Map n Int }

grid :: Int -> Int -> Graph (Int,Int)
grid a b = Graph $ \(x,y) ->
  let links = [((x+dx,y+dy), dx*dx+dy*dy)
              | dx <- [-1..1], dy <- [-1..1]
              , not (dx == 0 && dy == 0)
              , 0 <= x+dx && x+dx <= a
              , 0 <= y+dy && y+dy <= b]
  in Map.fromList links

withHole :: (Foldable t, Ord n) => Graph n -> t n -> Graph n
withHole (Graph g) ns = Graph $ \x ->
  if x `elem` ns
  then Map.empty
  else foldr Map.delete (g x) ns
