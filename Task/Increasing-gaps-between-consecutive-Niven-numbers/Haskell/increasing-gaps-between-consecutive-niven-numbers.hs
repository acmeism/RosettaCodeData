{-# LANGUAGE NumericUnderscores #-}
import Control.Monad (guard)
import Text.Printf (printf)
import Data.List (intercalate, unfoldr)
import Data.List.Split (chunksOf)
import Data.Tuple (swap)

nivens :: [Int]
nivens = [1..] >>= \n -> guard (n `rem` digitSum n == 0) >> [n]
 where
  digitSum = sum . unfoldr (\x -> guard (x > 0) >> pure (swap $ x `quotRem` 10))

findGaps :: [(Int, Int, Int)]
findGaps = go (zip [1..] nivens) 0
 where
  go [] n = []
  go r@((c, currentNiven):(_, nextNiven):xs) lastGap
   | gap > lastGap = (gap, c, currentNiven) : go (tail r) gap
   | otherwise     = go (tail r) lastGap
   where
    gap = nextNiven - currentNiven
  go (x:xs) _ = []

thousands :: Int -> String
thousands = reverse . intercalate "," . chunksOf 3 . reverse . show

main :: IO ()
main = do
  printf row "Gap" "Index of Gap" "Starting Niven"
  mapM_ (\(gap, gapIndex, niven) -> printf row (show gap) (thousands gapIndex) (thousands niven))
    $ takeWhile (\(_, gapIndex, _) -> gapIndex < 10_000_000) findGaps
 where
  row = "%5s%15s%15s\n"
