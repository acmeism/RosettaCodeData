knuthShuffleProcess :: (Show a) => [a] -> IO ()
knuthShuffleProcess =
   (mapM_ print. reverse =<<). ap (fmap. (. zip [1..]). scanr swapElems) (mkRands. length)
