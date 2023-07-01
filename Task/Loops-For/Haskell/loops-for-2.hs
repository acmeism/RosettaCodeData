import Data.List (inits)

main = mapM_ putStrLn $ tail $ inits $ replicate 5 '*'
