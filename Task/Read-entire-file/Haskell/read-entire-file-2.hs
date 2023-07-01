eagerReadFile :: FilePath -> IO String
eagerReadFile filepath = do
    text <- readFile filepath
    last text `seq` return text
