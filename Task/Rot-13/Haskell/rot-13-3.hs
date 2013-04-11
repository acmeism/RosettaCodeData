main = do
 names <- getArgs
 process (hInteract (map rot13)) names
