{-# LANGUAGE TupleSections, LambdaCase #-}
import Conduit
import Control.Monad.Random (getRandomR)
import Data.List (delete, find)

shuffleC :: Eq a => Int -> Conduit a IO a
shuffleC 0 = awaitForever yield
shuffleC k = takeC k .| sinkList >>= \v -> delay v .| randomReplace v

delay :: Monad m => [a] -> Conduit t m (a, [a])
delay [] = mapC $ \x -> (x,[x])
delay (b:bs) = await >>= \case
  Nothing -> yieldMany (b:bs) .| mapC (,[])
  Just x -> yield (b, [x]) >> delay (bs ++ [x])

randomReplace :: Eq a => [a] -> Conduit (a, [a]) IO a
randomReplace vars = awaitForever $ \(x,b) -> do
  y <- case filter (/= x) vars of
    [] -> pure x
    vs -> lift $ (vs !!) <$> getRandomR (0, length vs - 1)
  yield y
  randomReplace $ b ++ delete y vars

shuffleW :: Eq a => Int -> [a] -> IO [a]
shuffleW k lst = yieldMany lst =$= shuffleC k $$ sinkList
