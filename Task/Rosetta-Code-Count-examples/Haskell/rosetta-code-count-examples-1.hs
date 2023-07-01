import Network.Browser
import Network.HTTP
import Network.URI
import Data.List
import Data.Maybe
import Text.XML.Light
import Control.Arrow

justifyR w = foldl ((.return).(++).tail) (replicate w ' ')
showFormatted t n = t ++ ": " ++ justifyR 4 (show n)

getRespons url = do
    rsp <- Network.Browser.browse $ do
      setAllowRedirects True
      setOutHandler $ const (return ())     -- quiet
      request $ getRequest url
    return $ rspBody $ snd rsp

getNumbOfExampels p = do
  let pg = intercalate "_" $ words p
  rsp <- getRespons $ "http://www.rosettacode.org/w/index.php?title=" ++ pg ++ "&action=raw"
  let taskPage = rsp
      countEx = length $ filter (=="=={{header|") $ takeWhile(not.null) $ unfoldr (Just. (take 11 &&& drop 1)) taskPage
  return countEx

progTaskExamples = do
  rsp <- getRespons "http://www.rosettacode.org/w/api.php?action=query&list=categorymembers&cmtitle=Category:Programming_Tasks&cmlimit=500&format=xml"

  let xmls = onlyElems $ parseXML $ rsp
      tasks = concatMap (map (fromJust.findAttr (unqual "title")). filterElementsName (== unqual "cm")) xmls

  taskxx <- mapM getNumbOfExampels tasks
  let ns = taskxx
      tot = sum ns

  mapM_ putStrLn $ zipWith showFormatted tasks ns
  putStrLn $ ("Total: " ++) $ show tot
