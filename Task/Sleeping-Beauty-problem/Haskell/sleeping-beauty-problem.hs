import Data.Monoid   (Sum(..))
import System.Random (randomIO)
import Control.Monad (replicateM)
import Data.Bool     (bool)

data Toss = Heads | Tails deriving Show

anExperiment toss =
  moreWakenings <>
  case toss of
    Heads -> headsOnWaking
    Tails -> moreWakenings
  where
    moreWakenings = (1,0)
    headsOnWaking = (0,1)

main = do
  tosses <- map (bool Heads Tails) <$> replicateM 1000000 randomIO
  let (Sum w, Sum h) = foldMap anExperiment tosses
  let ratio = fromIntegral h / fromIntegral w
  putStrLn $ "Ratio: " ++ show ratio
