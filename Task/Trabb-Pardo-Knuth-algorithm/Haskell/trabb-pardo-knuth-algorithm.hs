import Control.Monad (replicateM_)

f x = (abs x) ** 0.5 + 5 * x ** 3

main = do
        putStrLn "Enter 11 numbers for evaluation"
        replicateM_ 11 $ getLine >>= (\x -> if x>400
                                                 then putStrLn "OVERFLOW"
                                                 else print x).f.read
