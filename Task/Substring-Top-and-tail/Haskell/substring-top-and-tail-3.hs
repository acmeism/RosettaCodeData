main :: IO ()
main = mapM_ print $ [tail, init, init . tail] <*> ["knights"]
