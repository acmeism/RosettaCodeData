import System.Posix.File

printFileSize filename = do stat <- getFileStatus filename
                            print (fileSize stat)

main = mapM_ printFileSize ["input.txt", "/input.txt"]
