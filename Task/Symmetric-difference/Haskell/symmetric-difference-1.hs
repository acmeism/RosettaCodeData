import Data.Set

a = fromList ["John", "Bob",  "Mary", "Serena"]
b = fromList ["Jim",  "Mary", "John", "Bob"]

(-|-) :: Ord a => Set a -> Set a -> Set a
(-|-) x y = (x \\ y) `union` (y \\ x)
  -- Equivalently: (x `union` y) \\ (x `intersect` y)
