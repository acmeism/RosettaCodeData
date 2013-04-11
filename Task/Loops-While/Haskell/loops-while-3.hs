import Data.IORef

main :: IO ()
main = do r <- newIORef 1024
          whileM (do n <- readIORef r
                     return (n > 0))
                 (do n <- readIORef r
                     print n
                     modifyIORef r (`div` 2))
