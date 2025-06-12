import Numeric.Natural (Natural)
import Data.Ratio as Rational

-- | Infinite List of Rational numbers in the series, zips itself to produce more values

v :: [Rational]
v = 2 : -4 : zipWith combine (drop 1 v) v
  where
    combine prev prev2 = 111 - 1130 / prev + 3000 / (prev * prev2)


-- >>> showRational 5 (1%3)
-- "+0.33333"

main :: IO ()
main = mapM_ (putStrLn . showRational 16 . (v !!)) [3, 4, 5, 6, 7, 8, 20, 30, 50, 100]
