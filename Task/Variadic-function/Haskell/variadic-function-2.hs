{-# LANGUAGE GADTs #-}
...

instance a ~ () => PrintAllType (IO a) where
    process args = do mapM_ putStrLn args

...
