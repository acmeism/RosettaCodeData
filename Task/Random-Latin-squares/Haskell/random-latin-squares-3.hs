import Control.Monad.State

type Random a = State Int a

random :: Integral a => a -> Random a
random k = rescale <$> modify iter
  where
    iter x = (x * a + c) `mod` m
    (a, c, m) = (1103515245, 12345, 2^31-1)
    rescale x = fromIntegral x `mod` k

randomPermutation :: Eq a => [a] -> Random [a]
randomPermutation = go
  where
    go [] = pure []
    go lst = do
      x <- randomSample lst
      (x :) <$> go (lst \\ [x])

randomSample :: [a] -> Random a
randomSample lst = (lst !!) <$> random (length lst)
