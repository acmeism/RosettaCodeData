import Control.Concurrent
import System.Random

concurrent :: IO ()
concurrent = do
    var <- newMVar [] -- use an MVar to collect the results of each thread
    mapM_ (forkIO . task var) ["Enjoy", "Rosetta", "Code"] -- run 3 threads
    putStrLn "Press Return to show the results." -- while we wait for the user,
    -- the threads run
    _ <- getLine
    takeMVar var >>= mapM_ putStrLn -- read the results and show them on screen
    where
        -- "task" is a thread
        task v s = do
            randomRIO (1,10) >>= \r -> threadDelay (r * 100000) -- wait a while
            val <- takeMVar v -- read the MVar and block other threads from reading it
            -- until we write another value to it
            putMVar v (s : val) -- append a text string to the MVar and block other
            -- threads from writing to it unless it is read first
