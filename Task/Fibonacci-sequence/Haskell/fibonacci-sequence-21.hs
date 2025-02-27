hsequence :: Monad m => [[x] -> m x] -> m [x]
hsequence []     = pure []
hsequence (r:rs) = do
    x <- r []
    xs <- hsequence [ \ys -> g (x:ys) | g <- rs ]
    pure (x:xs)
