import Control.Monad
import Control.Concurrent
import Data.Time

getTime :: IO DiffTime
getTime = fmap utctDayTime getCurrentTime

addSample :: MVar [a] -> a -> IO ()
addSample q v = modifyMVar_ q (return . (v:))

timeit :: Int -> IO a -> IO [DiffTime]
timeit n task = do
    samples <- newMVar []
    forM_ [0..n] $ \n -> do
        t1 <- getTime
        task
        t2 <- getTime
        addSample samples (t2 - t1)

    readMVar samples

main = timeit 10 (threadDelay 1000000)
