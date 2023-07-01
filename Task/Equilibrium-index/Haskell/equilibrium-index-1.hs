import System.Random (randomRIO)
import Data.List (findIndices, takeWhile)
import Control.Monad (replicateM)
import Control.Arrow ((&&&))

equilibr xs =
  findIndices (\(a, b) -> sum a == sum b) . takeWhile (not . null . snd) $
  flip ((&&&) <$> take <*> (drop . pred)) xs <$> [1 ..]

langeSliert = replicateM 2000 (randomRIO (-15, 15) :: IO Int) >>= print . equilibr
