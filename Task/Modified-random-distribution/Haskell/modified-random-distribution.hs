import System.Random
import Data.List
import Text.Printf

modify :: Ord a => (a -> a) -> [a] -> [a]
modify f = foldMap test . pairs
  where
    pairs lst = zip lst (tail lst)
    test (r1, r2) = if r2 < f r1 then [r1] else []

vShape x = if x < 0.5 then 2*(0.5-x) else 2*(x-0.5)

hist b lst = zip [0,b..] res
  where
    res = (`div` sum counts) . (*300) <$> counts
    counts = map length $ group $
             sort $ floor . (/b) <$> lst

showHist h = foldMap mkLine h
  where
    mkLine (b,n) = printf "%.2f\t%s %d%%\n" b (replicate n '▇') n
