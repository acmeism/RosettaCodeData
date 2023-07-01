import Data.List (find, delete, (\\))
import Control.Applicative ((<|>))

------------------------------------------------------------

newtype Perimeter a = Perimeter [a]
  deriving Show

instance Eq a => Eq (Perimeter a) where
  Perimeter p1 == Perimeter p2 =
    null (p1 \\ p2)
    && ((p1 `elem` zipWith const (iterate rotate p2) p1)
        || Perimeter p1 == Perimeter (reverse p2))

rotate lst = zipWith const (tail (cycle lst)) lst

toEdges :: Ord a => Perimeter a -> Maybe (Edges a)
toEdges (Perimeter ps)
  | allDifferent ps = Just . Edges $ zipWith ord ps (tail (cycle ps))
  | otherwise = Nothing
  where
    ord a b = if a < b then (a, b) else (b, a)

allDifferent [] = True
allDifferent (x:xs) = all (x /=) xs && allDifferent xs

------------------------------------------------------------

newtype Edges a = Edges [(a, a)]
  deriving Show

instance Eq a => Eq (Edges a) where
  e1 == e2 = toPerimeter e1 == toPerimeter e2

toPerimeter :: Eq a => Edges a -> Maybe (Perimeter a)
toPerimeter (Edges ((a, b):es)) = Perimeter . (a :) <$> go b es
  where
    go x rs
      | x == a = return []
      | otherwise = do
          p <- find ((x ==) . fst) rs <|> find ((x ==) . snd) rs
          let next = if fst p == x then snd p else fst p
          (x :) <$> go next (delete p rs)
