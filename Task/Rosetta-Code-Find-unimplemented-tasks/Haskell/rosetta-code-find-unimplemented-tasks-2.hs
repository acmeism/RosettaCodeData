import Network.HTTP
import Data.Text (splitOn, pack, unpack)
import Data.List

getTasks :: String -> IO [String]
getTasks url = do
  resp <- simpleHTTP (getRequest url)
  body <- getResponseBody resp
  return $ tail $ map (unpack . head . splitOn  (pack "\"}")) $ splitOn (pack "\"title\":\"") (pack body)

main :: String -> IO ()
main lang = do
  implTasks <- getTasks $ "http://rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:" ++ lang ++ "&format=json&cmlimit=500"
  allTasks <- getTasks "http://rosettacode.org/mw/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&format=json&cmlimit=500"
  mapM_ putStrLn $ allTasks \\ implTasks
