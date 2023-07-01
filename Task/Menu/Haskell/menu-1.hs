module RosettaSelect where

import Data.Maybe (listToMaybe)
import Control.Monad (guard)

select :: [String] -> IO String
select []   = return ""
select menu = do
  putStr $ showMenu menu
  putStr "Choose an item: "
  choice <- getLine
  maybe (select menu) return $ choose menu choice

showMenu :: [String] -> String
showMenu menu = unlines [show n ++ ") " ++ item | (n, item) <- zip [1..] menu]

choose :: [String] -> String -> Maybe String
choose menu choice = do
  n <- maybeRead choice
  guard $ n > 0
  listToMaybe $ drop (n-1) menu

maybeRead :: Read a => String -> Maybe a
maybeRead = fmap fst . listToMaybe . filter (null . snd) . reads
