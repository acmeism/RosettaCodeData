import System.Environment
import System.Directory
import System.FilePath.Find

search pat = find always (fileName ~~? pat)

main = do
  [pat] <- getArgs
  dir <- getCurrentDirectory
  files <- search pat dir
  mapM_ putStrLn files
