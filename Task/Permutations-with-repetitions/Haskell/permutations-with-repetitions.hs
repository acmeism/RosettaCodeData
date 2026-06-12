import Control.Monad (replicateM)

main = mapM_ print (replicateM 2 [1,2,3])
