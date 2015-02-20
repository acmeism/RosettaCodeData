import Data.List (unfoldr, genericSplitAt)

ludic :: [Integer]
ludic = 1 : unfoldr (\xs@(x:_) -> Just (x, dropEvery x xs)) [2..] where
  dropEvery n = concat . map tail . unfoldr (Just . genericSplitAt n)

main :: IO ()
main = do
  print $ take 25 $ ludic
  print $ length $ takeWhile (<= 1000) $ ludic
  print $ take 6 $ drop 1999 $ ludic
  -- haven't done triplets task yet
