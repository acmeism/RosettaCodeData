{-# LANGUAGE TupleSections #-}

import Data.List (mapAccumL)
import qualified Data.Map.Strict as M hiding (drop)
import Data.Maybe (maybe)

--------------------- VAN ECK SEQUENCE -------------------

vanEck :: [Int]
vanEck = 0 : snd (mapAccumL go (0, M.empty) [1 ..])
  where
    go (x, dct) i =
      ((,) =<< (, M.insert x i dct))
        (maybe 0 (i -) (M.lookup x dct))

--------------------------- TEST -------------------------
main :: IO ()
main =
  mapM_ print $
    fmap
      ((drop . subtract 10) <*> flip take vanEck)
      [10, 1000, 10000, 100000, 1000000]
