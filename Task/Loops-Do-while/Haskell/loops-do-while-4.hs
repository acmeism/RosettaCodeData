import Data.IORef
import Control.Monad.Loops

main = do
  x <- newIORef 0;
  iterateWhile (\val -> val `mod` 6 /= 0 ) $ do
    modifyIORef x (+1)
    val <- readIORef x
    print val
    return val
