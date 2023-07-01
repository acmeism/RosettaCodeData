import Crypto.Hash.MD5        (hash)
import Data.ByteString as BS  (readFile, ByteString())
import System.Environment     (getArgs, getProgName)
import System.Directory       (doesDirectoryExist, getDirectoryContents)
import System.FilePath.Posix  ((</>))
import Control.Monad          (forM)
import Text.Printf            (printf)
import System.IO              (withFile, IOMode(ReadMode), hFileSize)


type File = (BS.ByteString, -- md5hash
             FilePath)      -- filepath

type FileSize = Integer

getRecursiveContents :: FilePath -> FileSize -> IO [File]
getRecursiveContents curDir maxsize = do
  names <- getDirectoryContents curDir
  let dirs = filter (`notElem` [".", ".."]) names
  files <- forM dirs $ \path -> do
             let path' = curDir </> path
             exists <- doesDirectoryExist path'
             if exists
                then getRecursiveContents path' maxsize
                else genFileHash path' maxsize
  return $ concat files


genFileHash :: FilePath -> FileSize -> IO [File]
genFileHash path maxsize = do
  size <- withFile path ReadMode hFileSize
  if size <= maxsize
    then BS.readFile path >>= \bs -> return [(hash bs, path)]
    else return []

findDuplicates :: FilePath -> FileSize -> IO ()
findDuplicates dir bytes = do
  exists <- doesDirectoryExist dir
  if exists
    then getRecursiveContents dir bytes >>= findSameHashes
    else printf "Sorry, the directory \"%s\" does not exist...\n" dir

findSameHashes :: [File] -> IO ()
findSameHashes []     = return ()
findSameHashes ((hash, fp):xs) = do
  case lookup hash xs of
    (Just dupFile) -> printf "===========================\n\
                            \Found duplicate:\n\
                            \=> %s \n\
                            \=> %s \n\n" fp dupFile
                      >> findSameHashes xs
    (_)            -> findSameHashes xs

main :: IO ()
main = do
  args <- getArgs
  case args of
    [dir, mbytes] | [(bytes ,"")] <- reads mbytes
                   , bytes >= 1 -> findDuplicates dir bytes
    (_) -> do
      name <- getProgName
      printf "Something went wrong - please use ./%s <dir> <bytes>\n" name
