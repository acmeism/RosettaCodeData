import Control.Concurrent
import Control.Monad

worker :: QSem -> MVar String -> Int -> IO ()
worker q m n = do
    waitQSem q
    putMVar m $ "Worker " ++ show n ++ " has acquired the lock."
    threadDelay 2000000 -- microseconds!
    signalQSem q
    putMVar m $ "Worker " ++ show n ++ " has released the lock."

main :: IO ()
main = do
    q <- newQSem 3
    m <- newEmptyMVar
    let workers = 5
        prints  = 2 * workers
    mapM_ (forkIO . worker q m) [1..workers]
    replicateM_ prints $ takeMVar m >>= print
