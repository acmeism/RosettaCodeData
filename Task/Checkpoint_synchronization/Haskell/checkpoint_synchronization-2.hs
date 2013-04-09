import Control.Concurrent
import Control.Monad        -- needed for "forM", "forM_"

-- (workers working, workers done, workers total)
type Workshop = MVar (Int, Int, Int)
-- list of IO actions to be performed by one worker
type Actions = [IO ()]

newWorkshop :: IO Workshop
newWorkshop = newMVar (0, 0, 0)

-- check point: workers wait here for the other workers to
-- finish, before resuming execution/restarting
checkPoint :: Workshop -> IO ()
checkPoint w = do
    (working, done, count) <- takeMVar w
    -- all workers are done: reset counters and return (threads
    -- resume execution or restart)
    if working <= 0 && done == count
    then do
            putStrLn "---- Check Point"
            putMVar w (0, 0, count)
    -- mvar was just initialized: do nothing, just return.
    -- otherwise, a race condition may arise
    else if working == 0 && done == 0
            then putMVar w (working, done, count)
    -- workers are still working: wait for them (loop)
    else do
            putMVar w (working, done, count)
            checkPoint w

-- join the workshop
addWorker :: Workshop -> ThreadId -> IO ()
addWorker w i = do
    (working, done, count) <- takeMVar w
    putStrLn $ "Worker " ++ show i ++ " has joined the group."
    putMVar w (working, done, count + 1)

-- leave the workshop
removeWorker :: Workshop -> ThreadId -> IO ()
removeWorker w i = do
    (working, done, count) <- takeMVar w
    putStrLn $ "Worker " ++ show i ++ " has left the group."
    putMVar w (working, done, count - 1)

-- increase the number of workers doing something.
-- optionally, print a message using the thread's ID
startWork :: Workshop -> ThreadId -> IO ()
startWork w i = do
    (working, done, count) <- takeMVar w
    putStrLn $ "Worker " ++ show i ++ " has started."
    putMVar w (working + 1, done, count)

-- decrease the number of workers doing something and increase the
-- number of workers done. optionally, print a message using
-- the thread's ID
finishWork :: Workshop -> ThreadId -> IO ()
finishWork w i = do
    (working, done, count) <- takeMVar w
    putStrLn $ "Worker " ++ show i ++ " is ready."
    putMVar w (working - 1, done + 1, count)

-- put a worker to do his tasks. the steps are:
-- 1. join the workshop "w"
-- 2. report that the worker has started an action
-- 3. perform one action
-- 4. report that the worker is ready for the next action
-- 5. wait for the other workers to finish
-- 6. repeat from 2 until the worker has nothing more to do
-- 7. leave the workshop
worker :: Workshop -> Actions -> IO ()
worker w actions = do
    i <- myThreadId
    addWorker w i
    forM_ actions $ \action -> do
        startWork w i
        action
        finishWork w i
        checkPoint w
    removeWorker w i

-- launch several worker threads. their thread ID's are returned
shop :: Workshop -> [Actions] -> IO [ThreadId]
shop w actions = do
    forM actions $ \x -> forkIO (worker w x)

main = do
    -- make a workshop
    w <- newWorkshop

    -- the workers won't be doing anything special, just wait for n
    -- regular intervals. pids gathers the ID's of the threads

    -- this are the first workers joining the workshop
    pids1 <- shop w
        [replicate 5 $ threadDelay 1300000
        ,replicate 10 $ threadDelay 759191
        ,replicate 7 $ threadDelay 965300]

    -- wait for 5 secs before the next workers join
    threadDelay 5000000

    -- these are other workers that join the workshop later
    pids2 <- shop w
        [replicate 6 $ threadDelay 380000
        ,replicate 4 $ threadDelay 250000]

    -- wait for a key press
    getChar

    -- kill all worker threads before exit, if they're still running
    forM_ (pids1 ++ pids2) killThread
