import System.Directory (createDirectory, setCurrentDirectory)
import Data.List.Split  (splitOn)

main :: IO ()
main = do
  let path = splitOn "/" "path/to/dir"
  mapM_ (\x -> createDirectory x >> setCurrentDirectory x) path
