module AtomicUpdates (main) where

import Control.Concurrent (forkIO, threadDelay)
import Control.Concurrent.MVar (MVar, newMVar, readMVar, modifyMVar_)
import Control.Monad (forever, forM_)
import Data.IntMap (IntMap, (!), toAscList, fromList, adjust)
import System.Random (randomRIO)
import Text.Printf (printf)

-------------------------------------------------------------------------------

type Index = Int
type Value = Integer
data Buckets = Buckets Index (MVar (IntMap Value))

makeBuckets   :: Int -> IO Buckets
size          :: Buckets -> Index
currentValue  :: Buckets -> Index -> IO Value
currentValues :: Buckets          -> IO (IntMap Value)
transfer      :: Buckets -> Index -> Index -> Value -> IO ()

-------------------------------------------------------------------------------

makeBuckets n = do v <- newMVar (fromList [(i, 100) | i <- [1..n]])
                   return (Buckets n v)

size (Buckets n _) = n

currentValue (Buckets _ v) i = fmap (! i) (readMVar v)
currentValues (Buckets _ v) = readMVar v

transfer b@(Buckets n v) i j amt | amt < 0        = transfer b j i (-amt)
                                 | otherwise      = do
  modifyMVar_ v $ \map -> let amt' = min amt (map ! i)
                            in return $ adjust (subtract amt') i
                                      $ adjust (+        amt') j
                                      $ map

-------------------------------------------------------------------------------

roughen, smooth, display :: Buckets -> IO ()

pick buckets = randomRIO (1, size buckets)

roughen buckets = forever loop where
  loop = do i <- pick buckets
            j <- pick buckets
            iv <- currentValue buckets i
            transfer buckets i j (iv `div` 3)

smooth buckets = forever loop where
  loop = do i <- pick buckets
            j <- pick buckets
            iv <- currentValue buckets i
            jv <- currentValue buckets j
            transfer buckets i j ((iv - jv) `div` 4)

display buckets = forever loop where
  loop = do threadDelay 1000000
            bmap <- currentValues buckets
            putStrLn (report $ map snd $ toAscList bmap)
  report list = "\nTotal: " ++ show (sum list) ++ "\n" ++ bars
    where bars = concatMap row $ map (*40) $ reverse [1..5]
          row lim = printf "%3d " lim ++ [if x >= lim then '*' else ' ' | x <- list] ++ "\n"

main = do buckets <- makeBuckets 100
          forkIO (roughen buckets)
          forkIO (smooth buckets)
          display buckets
