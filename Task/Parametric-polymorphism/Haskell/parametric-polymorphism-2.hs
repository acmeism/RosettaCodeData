instance Functor Tree where
    fmap f Empty        = Empty
    fmap f (Node x l r) = Node (f x) (fmap f l) (fmap f r)
