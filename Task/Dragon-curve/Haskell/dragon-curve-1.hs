import Data.List
import Graphics.Gnuplot.Simple

-- diamonds
-- pl = [[0,1],[1,0]]

pl = [[0,0],[0,1]]
r_90 = [[0,1],[-1,0]]

ip :: [Int] -> [Int] -> Int
ip xs = sum . zipWith (*) xs
matmul xss yss = map (\xs -> map (ip xs ). transpose $ yss) xss

vmoot xs = (xs++).map (zipWith (+) lxs). flip matmul r_90.
          map (flip (zipWith (-)) lxs) .reverse . init $ xs
   where lxs = last xs

dragoncurve = iterate vmoot pl
