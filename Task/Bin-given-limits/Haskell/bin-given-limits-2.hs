{-# language DeriveFoldable #-}

import Data.Foldable (toList)

data BTree a b = Node a (BTree a b) (BTree a b)
               | Val b
  deriving Foldable

-- assuming list is sorted.
mkTree :: [a] -> BTree a [a]
mkTree [] = Val []
mkTree [x] = Node x (Val []) (Val [])
mkTree lst = Node x (mkTree l) (mkTree r)
  where (l, x:r) = splitAt (length lst `div` 2) lst

binSplit :: Ord a => [a] -> [a] -> [[a]]
binSplit lims = toList . foldr add (mkTree lims)
  where
    add x (Val v) = Val (x:v)
    add x (Node y l r) = if x < y
                         then Node y (add x l) r
                         else Node y l (add x r)
