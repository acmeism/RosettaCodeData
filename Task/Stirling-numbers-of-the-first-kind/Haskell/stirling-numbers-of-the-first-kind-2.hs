{-# LANGUAGE FlexibleContexts #-}

import Text.Printf (printf)
import Data.List (groupBy)
import Control.Monad.Memo (MonadMemo, memo, startEvalMemo)

stirling1 :: (Integral n, MonadMemo (n, n) n m) => (n, n) -> m n
stirling1 (n, k)
  | n == 0 && k == 0 = pure 1
  | n > 0 && k == 0 = pure 0
  | k > n           = pure 0
  | otherwise = (\f1 f2 -> f1 + pred n * f2) <$>
      memo stirling1 (pred n, pred k) <*> memo stirling1 (pred n, k)

stirling1Memo :: Integral n => (n, n) -> n
stirling1Memo = startEvalMemo . stirling1

main :: IO ()
main = do
  printf "n/k"
  mapM_ (printf "%10d") ([0..12] :: [Int]) >> printf "\n"
  printf "%s\n" $ replicate (13 * 10 + 3) '-'
  mapM_ (\row -> printf "%2d|" (fst $ head row) >>
    mapM_ (printf "%10d" . stirling1Memo) row >> printf "\n") table
  printf "\nThe maximum value of S1(100, k):\n%d\n" $
    maximum ([stirling1Memo (100, n) | n <- [1..100]] :: [Integer])
  where
    table :: [[(Int, Int)]]
    table = groupBy (\a b -> fst a == fst b) $ (,) <$> [0..12] <*> [0..12]
