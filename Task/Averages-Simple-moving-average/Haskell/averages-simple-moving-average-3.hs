import Control.Monad
import Control.Monad.State

period :: Int
period = 3

type SMAState = [Float]

computeSMA :: Float -> State SMAState Float
computeSMA x = do
  previousValues <- get
  let values = previousValues ++ [x]
  let newAverage = if length values <= period then (sum values) / (fromIntegral $ length remainingValues :: Float)
                   else (sum remainingValues) / (fromIntegral $ length remainingValues :: Float)
                     where remainingValues = dropIf period values
  put $ dropIf period values
  return newAverage

dropIf :: Int -> [a] -> [a]
dropIf x xs = drop ((length xs) - x) xs

demostrateSMA :: State SMAState [Float]
demostrateSMA = mapM computeSMA [1, 2, 3, 4, 5, 5, 4, 3, 2, 1]

main :: IO ()
main = print $ evalState demostrateSMA []
