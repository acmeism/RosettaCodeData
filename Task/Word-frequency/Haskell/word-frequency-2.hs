module Main where

import Control.Monad      (foldM, when)
import Data.Char          (isSpace, toLower)
import Data.List          (sortOn, filter)
import Data.Ord           (Down(..))
import System.IO          (stdin, IOMode(..), openFile, hClose)
import System.Environment (getArgs)
import Data.IORef         (IORef(..), newIORef, readIORef, modifyIORef') -- '

-- containers
import Data.HashMap.Strict (HashMap)
import qualified Data.HashMap.Strict as M

-- text
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

frequencies :: [Text] -> IO (HashMap Text (IORef Int))
frequencies = foldM (flip (M.alterF alter)) M.empty
 where
  alter Nothing    = Just <$> newIORef (1 :: Int)
  alter (Just ref) = modifyIORef' ref (+ 1) >> return (Just ref) -- '

main :: IO ()
main = do
  args <- getArgs
  when (length args /= 1) (error "expecting 1 arg (number of words to print)")
  let maxw = read $ head args -- no error handling, to simplify the example
  T.hGetContents stdin >>= \contents -> do
    freqtable <- frequencies $ filter (not . T.null) $ T.split isSpace $ T.map toLower contents
    counts <-
        let readRef (w, ref) = do
                cnt <- readIORef ref
                return (w, cnt)
         in mapM readRef $ M.toList freqtable
    print $ take maxw $ sortOn (Down . snd) counts
