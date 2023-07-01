{-# LANGUAGE TupleSections #-}

import Control.Monad (join)
import Data.List (partition, sortOn)
import Data.Ord (comparing)


------------------- SQUARE BUT NOT CUBE ------------------

isCube :: Int -> Bool
isCube n = n == round (fromIntegral n ** (1 / 3)) ^ 3

both, only :: [Int]
(both, only) = partition isCube $ join (*) <$> [1 ..]


--------------------------- TEST -------------------------
main :: IO ()
main =
  (putStrLn . unlines) $
    uncurry ((<>) . show)
      <$> sortOn
        fst
        ( ((," (also cube)") <$> take 3 both)
            <> ((,"") <$> take 30 only)
        )
