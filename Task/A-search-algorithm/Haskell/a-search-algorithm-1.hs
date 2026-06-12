{-# language DeriveFoldable #-}

module PQueue where

data PQueue a = EmptyQueue
              | Node (Int, a) (PQueue a) (PQueue a)
  deriving (Show, Foldable)

instance Ord a => Semigroup (PQueue a) where
  h1@(Node (w1, x1) l1 r1) <> h2@(Node (w2, x2) l2 r2)
    | w1 < w2   = Node (w1, x1) (h2 <> r1) l1
    | otherwise = Node (w2, x2) (h1 <> r2) l2
  EmptyQueue <> h = h
  h <> EmptyQueue = h

entry :: Ord a => a -> Int -> PQueue a
entry x w = Node (w, x) EmptyQueue EmptyQueue

enque :: Ord a => PQueue a -> a -> Int -> PQueue a
enque q x w = if x `notElem` q
              then entry x w <> q
              else q

deque :: Ord a => PQueue a -> Maybe (a, PQueue a)
deque q = case q of
            EmptyQueue -> Nothing
            Node (_, x) l r -> Just (x, l <> r)
