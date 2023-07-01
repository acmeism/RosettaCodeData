{-# LANGUAGE MonadComprehensions #-}
import Data.IORef
import Control.Monad.Loops

main :: IO ()
main = do
   r <- newIORef 1024
   whileM_ [n > 0 | n <- readIORef r] $ do
        n <- readIORef r
        print n
        modifyIORef r (`div` 2)
