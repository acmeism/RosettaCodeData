unusedIndices :: (Foldable t, Eq i) => [(i,a)] -> t i -> [i]
unusedIndices d = foldMap unused
  where unused i = maybe (pure i) (pure []) $ lookup i d

unusedData :: (Foldable t, Eq i) => [(i, a)] -> t i -> [(i,a)]
unusedData = foldr delete
  where delete i = filter ((i /= ) . fst)
