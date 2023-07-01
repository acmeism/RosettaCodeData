{-# LANGUAGE BangPatterns #-}

import Control.Monad
import Data.List
import Data.IORef

data Pair a b = Pair !a !b

mean :: Fractional a => [a] -> a
mean = divl . foldl' (\(Pair s l) x -> Pair (s+x) (l+1)) (Pair 0.0 0)
  where divl (_,0) = 0.0
        divl (s,l) = s / fromIntegral l

series = [1,2,3,4,5,5,4,3,2,1]

mkSMA :: Int -> IO (Double -> IO Double)
mkSMA period = avgr <$> newIORef []
  where avgr nsref x = readIORef nsref >>= (\ns ->
            let xs = take period (x:ns)
            in writeIORef nsref xs $> mean xs)

main = mkSMA 3 >>= (\sma3 -> mkSMA 5 >>= (\sma5 ->
    mapM_ (str <$> pure n <*> sma3 <*> sma5) series))
  where str n mm3 mm5 =
    concat ["Next number = ",show n,", SMA_3 = ",show mm3,", SMA_5 = ",show mm5]
