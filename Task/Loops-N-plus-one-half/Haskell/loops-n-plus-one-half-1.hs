main :: IO ()
main = forM_ [1 .. 10] $ \n -> do
            putStr $ show n
            putStr $ if n == 10 then "\n" else ", "
