when :: Monad m => m () -> Bool -> m ()
action `when` condition = if condition then action else return ()
