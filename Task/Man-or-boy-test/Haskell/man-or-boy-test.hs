import Control.Applicative (liftA2)
import Data.IORef (modifyIORef, newIORef, readIORef)

a
  :: (Enum a, Num b, Num a, Ord a)
  => a -> IO b -> IO b -> IO b -> IO b -> IO b -> IO b
a k x1 x2 x3 x4 x5 = do
  r <- newIORef k
  let b = do
        k <- pred ! r
        a k b x1 x2 x3 x4
  if k <= 0
    then liftA2 (+) x4 x5
    else b
  where
    f !r = modifyIORef r f >> readIORef r

main :: IO ()
main = a 10 # 1 # (-1) # (-1) # 1 # 0 >>= print
  where
    ( # ) f = f . return
