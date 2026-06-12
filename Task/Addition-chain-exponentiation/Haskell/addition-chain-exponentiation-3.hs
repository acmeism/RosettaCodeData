data M a = M [[a]] | I deriving Show

instance Num a => Semigroup (M a) where
  I <> m = m
  m <> I = m
  M m1 <> M m2 = M $ map (\r -> map (\c -> r `dot` c) (transpose m2)) m1
    where dot a b = sum $ zipWith (*) a b

instance Num a => Monoid (M a) where
  mempty = I
