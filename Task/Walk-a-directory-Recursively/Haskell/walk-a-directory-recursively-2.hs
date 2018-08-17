import System.FilePath.Posix
import System.Directory
import System.IO

dir_walk :: FilePath -> (FilePath -> IO ()) -> IO ()
dir_walk top filefunc = do
  isDirectory <- doesDirectoryExist top
  if isDirectory
    then
      do
        files <- listDirectory top
        mapM_ (\file -> dir_walk (top </> file) filefunc) files
    else
      filefunc top

main :: IO ()
main = do
         hSetEncoding stdout utf8
         hSetEncoding stdin  utf8
         let worker fname =
              do if (takeExtension fname == ".hs")
                   then putStrLn fname
                   else return ()
         dir_walk "." worker
