import Control.Monad
main = do
        number <- getLine
        input <- replicateM (read number) getLine
        mapM_ putStrLn input
