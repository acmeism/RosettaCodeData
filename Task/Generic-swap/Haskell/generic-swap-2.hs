import Control.Monad.Ref
swap :: MonadRef r m => r a -> r a -> m ()
swap xRef yRef = do
   x<-readRef xRef
   y<-readRef yRef
   writeRef xRef y
   writeRef yRef x
