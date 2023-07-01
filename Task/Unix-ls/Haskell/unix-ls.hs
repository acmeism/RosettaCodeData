import Control.Monad
import Data.List
import System.Directory

dontStartWith = flip $ (/=) . head

main = do
  files <- getDirectoryContents "."
  mapM_ putStrLn $ sort $ filter (dontStartWith '.') files
