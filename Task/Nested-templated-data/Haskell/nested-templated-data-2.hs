subst :: (Functor t, Eq i) => [(i,a)] -> t i -> t (Maybe a)
subst d = fmap (`lookup` d)
