instance (Ord a, Eq b) => Semigroup (Shortest b a) where
  a <> b = case distance a `compare` distance b of
    GT -> b
    LT -> a
    EQ -> a { path = path a `union` path b }
