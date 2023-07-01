import Control.Monad (replicateM)
import System.Random (randomRIO)
import Data.Bool (bool)
import Data.List (sort)

character :: IO [Int]
character =
  discardUntil
    (((&&) . (75 <) . sum) <*> ((2 <=) . length . filter (15 <=)))
    (replicateM 6 $ sum . tail . sort <$> replicateM 4 (randomRIO (1, 6 :: Int)))

discardUntil :: ([Int] -> Bool) -> IO [Int] -> IO [Int]
discardUntil p throw = go
  where
    go = throw >>= (<*>) (bool go . return) p

-------------------------- TEST ---------------------------
main :: IO ()
main = replicateM 10 character >>= mapM_ (print . (sum >>= (,)))
