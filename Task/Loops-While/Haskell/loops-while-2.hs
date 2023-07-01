import Data.IORef
import Control.Monad.Loops

main :: IO ()
main = do r <- newIORef 1024
          whileM_ (do n <- readIORef r
                     return (n > 0))
                  (do n <- readIORef r
                     print n
                     modifyIORef r (`div` 2))
