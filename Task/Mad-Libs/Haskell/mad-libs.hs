import System.IO
import System.Environment
import qualified Data.Map as M

getLines :: IO [String]
getLines = getLines' [] >>= return . reverse
    where
      getLines' xs = do
        line <- getLine
        case line of
          [] -> return xs
          _  -> getLines' $ line:xs

prompt :: String -> IO String
prompt p = putStr p >> hFlush stdout >> getLine

getKeyword :: String -> Maybe String
getKeyword ('<':xs) = getKeyword' xs []
    where
      getKeyword' []        _   = Nothing
      getKeyword' (x:'>':_) acc = Just $ '<' : (reverse $ '>':x:acc)
      getKeyword' (x:xs)    acc = getKeyword' xs $ x:acc
getKeyword _        = Nothing

parseText :: String -> M.Map String String -> IO String
parseText []          _        = return []
parseText line@(l:lx) keywords = do
  case getKeyword line of
    Nothing      -> parseText lx keywords >>= return . (l:)
    Just keyword -> do
      let rest = drop (length keyword) line
      case M.lookup keyword keywords of
        Nothing        -> do
                         newword <- prompt $ "Enter a word for " ++ keyword ++ ": "
                         rest'   <- parseText rest $ M.insert keyword newword keywords
                         return $ newword ++ rest'
        Just knownword -> do
                         rest' <- parseText rest keywords
                         return $ knownword ++ rest'

main :: IO ()
main = do
  args    <- getArgs
  nlines  <- case args of
               []    -> getLines >>= return . unlines
               arg:_ -> readFile arg
  nlines' <- parseText nlines M.empty
  putStrLn ""
  putStrLn nlines'
