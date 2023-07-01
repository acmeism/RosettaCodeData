import Data.Time.Clock
import Data.List

type Time = Integer
type Sorter a = [a] -> [a]

-- Simple timing function (in microseconds)
timed :: IO a -> IO (a, Time)
timed prog = do
  t0 <- getCurrentTime
  x <- prog
  t1 <- x `seq` getCurrentTime
  return (x, ceiling $ 1000000 * diffUTCTime t1 t0)

-- testing sorting algorithm on a given set
test :: [a] -> Sorter a -> IO [(Int, Time)]
test set srt = mapM (timed . run) ns
  where
    ns = take 15 $ iterate (\x -> (x * 5) `div` 3) 10
    run n = pure $ length $ srt (take n set)

-- sample sets
constant = repeat 1

presorted = [1..]

random = (`mod` 100) <$> iterate step 42
  where
    step x = (x * a + c) `mod` m
    (a, c, m) = (1103515245, 12345, 2^31-1)
