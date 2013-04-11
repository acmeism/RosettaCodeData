takeMVar :: MVar a -> IO a
putMVar :: MVar a -> a -> IO ()
tryTakeMVar :: MVar a -> IO (Maybe a)
tryPutMVar :: MVar a -> a -> IO Bool
