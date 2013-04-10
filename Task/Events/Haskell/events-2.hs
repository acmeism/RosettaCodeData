main = do e <- newEvent
          forkIO (waitTask e)
          putStrLn "[1] Waiting 1 second..."
          threadDelay 1000000 {- µs -}
          putStrLn "[1] Signaling event."
          signalEvent e
          threadDelay 1000000 {- µs -}    -- defer program exit for reception

waitTask e = do putStrLn "[2] Waiting for event..."
                waitEvent e
                putStrLn "[2] Received event."
