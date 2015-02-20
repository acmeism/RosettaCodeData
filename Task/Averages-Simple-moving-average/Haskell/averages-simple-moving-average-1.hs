import Control.Monad
import Data.List
import Data.IORef

mean :: Fractional a => [a] -> a
mean xs = sum xs / (genericLength xs)

series = [1,2,3,4,5,5,4,3,2,1]

simple_moving_averager period = do
  numsRef <- newIORef []
  return (\x -> do
            nums <- readIORef numsRef
            let xs = take period (x:nums)
            writeIORef numsRef xs
            return $ mean xs
         )

main = do
  sma3 <- simple_moving_averager 3
  sma5 <- simple_moving_averager 5
  forM_ series (\n -> do
                mm3 <- sma3 n
                mm5 <- sma5 n
                putStrLn $ "Next number = " ++ (show n) ++ ", SMA_3 = " ++ (show mm3) ++ ", SMA_5 = " ++ (show mm5)
               )
