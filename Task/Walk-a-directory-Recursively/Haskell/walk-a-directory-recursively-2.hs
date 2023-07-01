import System.FilePath.Posix
import System.Directory
import System.IO

dirWalk :: (FilePath -> IO ()) -> FilePath -> IO ()
dirWalk filefunc top = do
  isDirectory <- doesDirectoryExist top
  if isDirectory
    then do
      files <- listDirectory top
      mapM_ (dirWalk filefunc . (top </>)) files
    else filefunc top

main :: IO ()
main = do
  hSetEncoding stdout utf8
  hSetEncoding stdin utf8
  let worker fname
        | takeExtension fname == ".hs" = putStrLn fname
        | otherwise = return ()
  dirWalk worker "."
