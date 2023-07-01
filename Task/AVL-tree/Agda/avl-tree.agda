module Avl where

-- The Peano naturals
data Nat : Set where
 z : Nat
 s : Nat -> Nat

-- An AVL tree's type is indexed by a natural.
-- Avl N is the type of AVL trees of depth N. There arj 3 different
-- node constructors:
--   Left: The left subtree is one level deeper than the right
--   Balanced: The subtrees have the same depth
--   Right: The right Subtree is one level deeper than the left
-- Since the AVL invariant is that the depths of a node's subtrees
-- always differ by at most 1, this perfectly encodes the AVL depth invariant.
data Avl : Nat -> Set where
  Empty : Avl z
  Left : {X : Nat} -> Nat -> Avl (s X) -> Avl X -> Avl (s (s X))
  Balanced : {X : Nat} -> Nat -> Avl X -> Avl X -> Avl (s X)
  Right : {X : Nat} -> Nat -> Avl X -> Avl (s X) -> Avl (s (s X))

-- A wrapper type that hides the AVL tree invariant. This is the interface
-- exposed to the user.
data Tree : Set where
  avl : {N : Nat} -> Avl N -> Tree

-- Comparison result
data Ord : Set where
  Less : Ord
  Equal : Ord
  Greater : Ord

-- Comparison function
cmp : Nat -> Nat -> Ord
cmp z (s X) = Less
cmp z z = Equal
cmp (s X) z = Greater
cmp (s X) (s Y) = cmp X Y

-- Insertions can either leave the depth the same or
-- increase it by one. Encode this in the type.
data InsertResult : Nat -> Set where
  Same : {X : Nat} -> Avl X -> InsertResult X
  Bigger : {X : Nat} -> Avl (s X) -> InsertResult X

-- If the left subtree is 2 levels deeper than the right, rotate to the right.
-- balance-left X L R means X is the root, L is the left subtree and R is the right.
balance-left : {N : Nat} -> Nat -> Avl (s (s N)) -> Avl N -> InsertResult (s (s N))
balance-left X (Right Y A (Balanced Z B C)) D = Same (Balanced Z (Balanced X A B) (Balanced Y C D))
balance-left X (Right Y A (Left Z B C)) D = Same (Balanced Z (Balanced X A B) (Right Y C D))
balance-left X (Right Y A (Right Z B C)) D = Same (Balanced Z (Left X A B) (Balanced Y C D))
balance-left X (Left Y (Balanced Z A B) C) D = Same (Balanced Z (Balanced X A B) (Balanced Y C D))
balance-left X (Left Y (Left Z A B) C) D = Same (Balanced Z (Left X A B) (Balanced Y C D))
balance-left X (Left Y (Right Z A B) C) D = Same (Balanced Z (Right X A B) (Balanced Y C D))
balance-left X (Balanced Y (Balanced Z A B) C) D = Bigger (Right Z (Balanced X A B) (Left Y C D))
balance-left X (Balanced Y (Left Z A B) C) D =  Bigger (Right Z (Left X A B) (Left Y C D))
balance-left X (Balanced Y (Right Z A B) C) D = Bigger (Right Z (Right X A B) (Left Y C D))

-- Symmetric with balance-left
balance-right : {N : Nat} -> Nat -> Avl N -> Avl (s (s N)) -> InsertResult (s (s N))
balance-right X A (Left Y (Left Z B C) D) = Same (Balanced Z (Balanced X A B) (Right Y C D))
balance-right X A (Left Y (Balanced Z B C) D) = Same(Balanced Z (Balanced  X A B) (Balanced Y C D))
balance-right X A (Left Y (Right Z B C) D) = Same(Balanced Z (Left X A B) (Balanced Y C D))
balance-right X A (Balanced Z B (Left Y C D)) = Bigger(Left Z (Right X A B) (Left Y C D))
balance-right X A (Balanced Z B (Balanced Y C D)) = Bigger (Left Z (Right X A B) (Balanced Y C D))
balance-right X A (Balanced Z B (Right Y C D)) = Bigger (Left Z (Right X A B) (Right Y C D))
balance-right X A (Right Z B (Left Y C D)) = Same (Balanced Z (Balanced X A B) (Left Y C D))
balance-right X A (Right Z B (Balanced Y C D)) = Same (Balanced Z (Balanced X A B) (Balanced Y C D))
balance-right X A (Right Z B (Right Y C D)) =  Same (Balanced Z (Balanced X A B) (Right Y C D))

-- insert' T N does all the work of inserting the element N into the tree T.
insert' : {N : Nat} -> Avl N -> Nat -> InsertResult N
insert' Empty N = Bigger (Balanced N Empty Empty)
insert' (Left Y L R) X with cmp X Y
insert' (Left Y L R) X | Less with insert' L X
insert' (Left Y L R) X | Less | Same L' = Same (Left Y L' R)
insert' (Left Y L R) X | Less | Bigger L' = balance-left Y L' R
insert' (Left Y L R) X | Equal = Same (Left Y L R)
insert' (Left Y L R) X | Greater with insert' R X
insert' (Left Y L R) X | Greater | Same R' = Same (Left Y L R')
insert' (Left Y L R) X | Greater | Bigger R' = Same (Balanced Y L R')
insert' (Balanced Y L R) X with cmp X Y
insert' (Balanced Y L R) X | Less with insert' L X
insert' (Balanced Y L R) X | Less | Same L'  = Same (Balanced Y L' R)
insert' (Balanced Y L R) X | Less | Bigger L' = Bigger (Left Y L' R)
insert' (Balanced Y L R) X | Equal = Same (Balanced Y L R)
insert' (Balanced Y L R) X | Greater with insert' R X
insert' (Balanced Y L R) X | Greater | Same R' = Same (Balanced Y L R')
insert' (Balanced Y L R) X | Greater | Bigger R' = Bigger (Right Y L R')
insert' (Right Y L R) X with cmp X Y
insert' (Right Y L R) X | Less with insert' L X
insert' (Right Y L R) X | Less | Same L' = Same (Right Y L' R)
insert' (Right Y L R) X | Less | Bigger L' = Same (Balanced Y L' R)
insert' (Right Y L R) X | Equal = Same (Right Y L R)
insert' (Right Y L R) X | Greater with insert' R X
insert' (Right Y L R) X | Greater | Same R' = Same (Right Y L R')
insert' (Right Y L R) X | Greater | Bigger R' = balance-right Y L R'

-- Wrapper around insert' to use the depth-agnostic type Tree.
insert : Tree -> Nat  -> Tree
insert (avl T) X with insert' T X
... | Same T' = avl T'
... | Bigger T' = avl T'
