import Control.Concurrent
import Control.Concurrent.MVar

main =
    do lineVar <- newEmptyMVar
       countVar <- newEmptyMVar

       let takeLine  = takeMVar lineVar
           putLine   = putMVar lineVar . Just
           putEOF    = putMVar lineVar Nothing
           takeCount = takeMVar countVar
           putCount  = putMVar countVar

       forkIO $ writer takeLine putCount
       reader putLine putEOF takeCount
