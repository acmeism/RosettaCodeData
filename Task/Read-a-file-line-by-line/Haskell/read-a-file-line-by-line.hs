main = do
  file <- readFile "linebyline.hs"
  mapM_ putStrLn (lines file)
