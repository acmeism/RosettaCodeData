import System.Directory (doesFileExist, doesDirectoryExist)

check :: (FilePath -> IO Bool) -> FilePath -> IO ()
check p s = do
  result <- p s
  putStrLn $
    s ++
    if result
      then " does exist"
      else " does not exist"

main :: IO ()
main = do
  check doesFileExist "input.txt"
  check doesDirectoryExist "docs"
  check doesFileExist "/input.txt"
  check doesDirectoryExist "/docs"
