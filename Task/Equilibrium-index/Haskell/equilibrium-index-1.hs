import System.Random (randomRIO)
import Data.List (elemIndices, takeWhile)
import Control.Monad (replicateM, liftM2)
import Control.Arrow ((&&&))

equilibr xs = elemIndices True . map (uncurry $ (. sum) . (==) . sum) .
  takeWhile (not . null . snd) $ map (flip (liftM2 (&&&) take $ drop . pred) xs) [1..]

langeSliert =
  replicateM 2000 (randomRIO (-15,15) :: IO Int)
   >>= print . equilibr
