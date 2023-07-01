import System.Environment
import System.IO
import System.Directory
import Control.Monad

hInteract :: (String -> String) -> Handle -> Handle -> IO ()
hInteract f hIn hOut =
  hGetContents hIn >>= hPutStr hOut . f

processByTemp :: (Handle -> Handle -> IO ()) -> String -> IO ()
processByTemp f name = do
  hIn <- openFile name ReadMode
  let tmp = name ++ "$"
  hOut <- openFile tmp WriteMode
  f hIn hOut
  hClose hIn
  hClose hOut
  removeFile name
  renameFile tmp name

process :: (Handle -> Handle -> IO ()) -> [String] -> IO ()
process f [] = f stdin stdout
process f ns = mapM_ (processByTemp f) ns
