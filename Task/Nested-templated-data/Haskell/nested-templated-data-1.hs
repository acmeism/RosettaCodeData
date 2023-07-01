{-# language DeriveTraversable #-}

data Template a = Val a | List [Template a]
  deriving ( Show
           , Functor
           , Foldable
           , Traversable )
