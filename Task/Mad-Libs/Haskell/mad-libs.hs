import System.IO (stdout, hFlush)

import System.Environment (getArgs)

import qualified Data.Map as M (Map, lookup, insert, empty)

getLines :: IO [String]
getLines = reverse <$> getLines_ []
  where
    getLines_ xs = do
      line <- getLine
      case line of
        [] -> return xs
        _ -> getLines_ $ line : xs

prompt :: String -> IO String
prompt p = putStr p >> hFlush stdout >> getLine

getKeyword :: String -> Maybe String
getKeyword ('<':xs) = getKeyword_ xs []
  where
    getKeyword_ [] _ = Nothing
    getKeyword_ (x:'>':_) acc = Just $ '<' : reverse ('>' : x : acc)
    getKeyword_ (x:xs) acc = getKeyword_ xs $ x : acc
getKeyword _ = Nothing

parseText :: String -> M.Map String String -> IO String
parseText [] _ = return []
parseText line@(l:lx) keywords =
  case getKeyword line of
    Nothing -> (l :) <$> parseText lx keywords
    Just keyword -> do
      let rest = drop (length keyword) line
      case M.lookup keyword keywords of
        Nothing -> do
          newword <- prompt $ "Enter a word for " ++ keyword ++ ": "
          rest_ <- parseText rest $ M.insert keyword newword keywords
          return $ newword ++ rest_
        Just knownword -> do
          rest_ <- parseText rest keywords
          return $ knownword ++ rest_

main :: IO ()
main = do
  args <- getArgs
  nlines <-
    case args of
      [] -> unlines <$> getLines
      arg:_ -> readFile arg
  nlines_ <- parseText nlines M.empty
  putStrLn ""
  putStrLn nlines_
