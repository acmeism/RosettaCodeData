import Control.Monad (when)

whileM :: (Monad m) => m Bool -> m a -> m ()
whileM cond body = do c <- cond
                      when c (body >> whileM cond body)
