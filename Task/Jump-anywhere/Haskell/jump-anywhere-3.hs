import Data.IORef

readInt = lift $ readLn >>= newIORef
get ref = lift $ readIORef ref
set ref expr = lift $ modifyIORef ref (const expr)
output expr = lift $ putStrLn expr
