import Data.List (sortBy)
import Data.Ord (comparing)
import System.Random (newStdGen, randomRs)

--------------------- IN RANDOM ORDER --------------------

inRandomOrder :: [a] -> IO [a]
inRandomOrder xs =
  fmap fst . sortBy (comparing snd) . zip xs
    <$> (randomRs (0, 1) <$> newStdGen :: IO [Double])

--------------------------- TEST -------------------------
main :: IO ()
main =
  inRandomOrder [1 .. 20]
    >>= print
