import Control.Monad (replicateM_)

sampleFunction :: IO ()
sampleFunction = putStrLn "a"

main = replicateM_ 5 sampleFunction
