module Main where

import Control.Category   -- (>>>)
import Data.Char          -- toLower, isSpace
import Data.List          -- sortBy, (Foldable(foldl')), filter -- '
import Data.Ord           -- Down
import System.IO          -- stdin, ReadMode, openFile, hClose
import System.Environment -- getArgs

-- containers
import Data.Map.Strict (Map)
import qualified Data.Map.Strict as M
import qualified Data.IntMap.Strict as IM

-- text
import Data.Text (Text)
import qualified Data.Text as T
import qualified Data.Text.IO as T

frequencies :: Ord a => [a] -> Map a Integer
frequencies = foldl' (\m k -> M.insertWith (+) k 1 m) M.empty -- '
{-# SPECIALIZE frequencies :: [Text] -> Map Text Integer #-}

main :: IO ()
main = do
  args <- getArgs
  (n,hand,filep) <- case length args of
    0 -> return (10,stdin,False)
    1 -> return (read $ head args,stdin,False)
    _ -> let (ns:fp:_) = args
         in fmap (\h -> (read ns,h,True)) (openFile fp ReadMode)
  T.hGetContents hand >>=
    (T.map toLower
      >>> T.split isSpace
      >>> filter (not <<< T.null)
      >>> frequencies
      >>> M.toList
      >>> sortBy (comparing (Down <<< snd)) -- sort the opposite way
      >>> take n
      >>> print)
  when filep (hClose hand)
