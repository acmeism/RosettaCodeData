import System.IO (readFile)
import Data.List (isInfixOf)

main = do
  txt <- readFile "unixdict.txt"
  let res = [ w | w <- lines txt, isInfixOf "the" w, length w > 11 ]
  putStrLn $ show (length res) ++ " words were found:"
  mapM_ putStrLn res
