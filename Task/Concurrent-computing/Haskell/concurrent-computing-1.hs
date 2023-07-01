import Control.Concurrent

main = mapM_ forkIO [process1, process2, process3] where
  process1 = putStrLn "Enjoy"
  process2 = putStrLn "Rosetta"
  process3 = putStrLn "Code"
