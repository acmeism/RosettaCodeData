{-# language DeriveFoldable #-}
import Data.Foldable

-- double-linked list
data DList a = End | Elem { prev :: DList a
                           , elt :: a
                           , next :: DList a }

mkDList :: Foldable t => t a -> DList a
mkDList = go End . toList
  where go _    []     = End
        go prev (x:xs) = current
          where current = Elem prev x next
                next    = go current xs

instance Foldable DList where
  foldMap f End = mempty
  foldMap f dl = f (elt dl) <> foldMap f (next dl)

sortDL :: Ord a => DList a -> DList a
sortDL = mkDList . mkTree

-- binary tree
data BTree a = Empty | Node { left  :: BTree a
                            , node  :: a
                            , right :: BTree a }
  deriving (Show, Foldable)

addTree Empty x = Node Empty x Empty
addTree (Node l a g) x =
  case compare x a of
    LT -> Node (addTree l x) a g
    _  -> Node l a (addTree g x)

mkTree :: (Foldable t, Ord a) => t a -> BTree a
mkTree = foldl addTree Empty

treeSort :: (Foldable t, Ord a) => t a -> [a]
treeSort = toList . mkTree
