import System.Directory (getDirectoryContents)
import System.Environment (getArgs)


isEmpty x = getDirectoryContents x >>= return . f . (== [".", ".."])
    where f True = "Directory is empty"
          f False = "Directory is not empty"

main = getArgs >>= isEmpty . (!! 0) >>= putStrLn
