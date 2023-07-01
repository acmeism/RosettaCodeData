import System.IO

printFileSize filename = withFile filename ReadMode hFileSize >>= print

main = mapM_ printFileSize ["input.txt", "/input.txt"]
